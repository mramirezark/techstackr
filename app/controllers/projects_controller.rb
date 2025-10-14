class ProjectsController < ApplicationController
  before_action :set_project, only: [ :show ]

  def index
    @projects = Project.includes(recommendation: [ :technologies, :team_members ])
                      .order(created_at: :desc)
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)

    if @project.save
      redirect_to @project, notice: "Project was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @recommendation = @project.recommendation
  end

  private

  def set_project
    @project = Project.includes(recommendation: [ :technologies, :team_members ]).find(params[:id])
  end

  def project_params
    params.require(:project).permit(:title, :description, :project_type)
  end
end
