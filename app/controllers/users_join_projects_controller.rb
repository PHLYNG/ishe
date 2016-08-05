class UsersJoinProjectsController < ApplicationController
  def index
  end

  def new
  end

  def create
    @project = Project.find(params[:project_id])

    # can't really move to model
    if @project.user_join_projects.first
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
