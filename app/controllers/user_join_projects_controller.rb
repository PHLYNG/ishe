class UserJoinProjectsController < ApplicationController

  def index
    @project = Project.find(params[:project_id])
    @ujps = @project.user_join_projects
    respond_to do |format|
      format.html
      format.json { render json: [@project, @ujps], status: :ok, location: @project }
    end
  end

  def new
  end

  def create
    binding.pry
    @project = Project.find(params[:project_id])

    # can't really move to model
    if @project.user_join_projects.first
      # merge projects
      # create Team
      flash[:danger] = "There is already a Team for this Project"
      redirect_to @project
    else
      @user_join_project = UserJoinProject.create!(user_join_project_params.merge({user: current_user}))

      redirect_to @project
    end
  end

  def save
  end

  def delete
  end

  private
  def user_join_project_params
    params.require(:user_join_project).permit(:project, :user)
  end

end
