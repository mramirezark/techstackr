class ProjectsController < ApplicationController
  before_action :set_project, only: [ :show, :edit, :update, :destroy, :modal_details, :modal_edit, :modal_delete ]

  def index
    @projects = current_user.projects.includes(recommendation: [ :technologies, :team_members ])
                      .order(created_at: :desc)
                      .page(params[:page]).per(10)
  end

  def dashboard
    @projects = current_user.projects.includes(recommendation: [ :technologies, :team_members ])
                      .where(status: "completed")
                      .order(created_at: :desc)

    # Calculate statistics
    @total_recommendations = @projects.size  # Use size instead of count to avoid query
    @total_technologies = Technology.joins(recommendation: :project)
                                    .where(projects: { user_id: current_user.id })
                                    .distinct
                                    .count
    @total_team_members = current_user.projects
                                      .where(status: "completed")
                                      .sum(:estimated_team_size)

    # Popular technologies
    @popular_technologies = Technology.joins(recommendation: :project)
                                      .where(projects: { user_id: current_user.id })
                                      .group(:name, :category)
                                      .count
                                      .sort_by { |_, count| -count }
                                      .first(10)

    # Popular roles
    @popular_roles = TeamMember.joins(recommendation: :project)
                                .where(projects: { user_id: current_user.id })
                                .group(:role)
                                .sum(:count)
                                .sort_by { |_, count| -count }
                                .first(10)

    # Industries breakdown (use pluck to avoid ordering issues)
    @industries = current_user.projects.where(status: "completed")
                              .group(:industry)
                              .count
  end

  def new
    @project = Project.new
  end

  def create
    @project = current_user.projects.build(project_params)

    respond_to do |format|
      if @project.save
        format.html { redirect_to @project, notice: "Project was successfully created." }
        format.json { render json: { success: true, redirect_url: project_path(@project) }, status: :created }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: { success: false, errors: @project.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  def show
    @recommendation = @project.recommendation
  end

  def modal_details
    @recommendation = @project.recommendation

    respond_to do |format|
      format.html { render partial: "modal_details", layout: false }
      format.json { render json: @project }
    end
  end

  def modal_new
    @project = Project.new

    respond_to do |format|
      format.html { render partial: "modal_new", layout: false }
    end
  end

  def edit
  end

  def modal_edit
    respond_to do |format|
      format.html { render partial: "modal_edit", layout: false }
    end
  end

  def modal_delete
    respond_to do |format|
      format.html { render partial: "modal_delete", layout: false }
    end
  end

  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to projects_path, notice: "Project '#{@project.title}' was successfully updated." }
        format.json { render json: { success: true, message: "Project '#{@project.title}' was successfully updated.", redirect_url: projects_path }, status: :ok }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: { success: false, errors: @project.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    title = @project.title
    @project.destroy

    respond_to do |format|
      format.html { redirect_to projects_path, notice: "Project '#{title}' was successfully deleted." }
      format.json { render json: { success: true, message: "Project '#{title}' was successfully deleted.", redirect_url: projects_path }, status: :ok }
    end
  end

  private

  def set_project
    @project = current_user.projects.includes(recommendation: [ :technologies, :team_members ]).find(params[:id])
  end

  def project_params
    params.require(:project).permit(:title, :description, :project_type, :industry, :estimated_team_size)
  end
end
