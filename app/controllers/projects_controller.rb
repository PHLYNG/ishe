class ProjectsController < ApplicationController
  def index
    # need to test if using current_user here works, currently defined in SessionsHelper. May need to define current_user in projects helper? But helpers are used only in views, define in model?
    @projects = current_user.projects
  end

  def new
    @project = Project.new
  end

  def create
    # project does not take a user id on create because the association is stored in the user_join_projects join table?
    @project = Project.find_or_create_by(project_params)
    UserJoinProject.create!({user: current_user, project: @project})
    # .merge({user_id: current_user.id}))
    redirect_to current_user
  end

  def show
    @projects = Project.find(params[:id])
    @user = current_user
  end

  def update
  end

  def destroy
    proj = Project.find(params[:id])
    ujp = UserJoinProject.where(project_id: proj.id)
    ujp.delete_all
    proj.delete
    redirect_to current_user
  end

  private

  def project_params
    params.require(:project).permit(:project_type, :street1, :street2, :project_action_date, :project_complete)
  end

  # def user_join_project_params
  #   params.require(:user_join_project).permit(:project, :user)
  # end
end
