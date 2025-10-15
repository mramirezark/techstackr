class ProjectsController < ApplicationController
  before_action :set_project, only: [ :show, :modal_details ]

  def index
    @projects = current_user.projects.includes(recommendation: [ :technologies, :team_members ])
                      .order(created_at: :desc)
  end

  def new
    @project = Project.new
  end

  def create
    @project = current_user.projects.build(project_params)

    if @project.save
      redirect_to @project, notice: "Project was successfully created."
    else
      render :new, status: :unprocessable_entity
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

  private

  def set_project
    @project = current_user.projects.includes(recommendation: [ :technologies, :team_members ]).find(params[:id])
  end

  def project_params
    params.require(:project).permit(:title, :description, :project_type, :industry, :estimated_team_size)
  end
end
