class ProjectsController < ApplicationController
  def index
    # need to test if using current_user here works, currently defined in SessionsHelper. May need to define current_user in projects helper? But helpers are used only in views, define in model?
    @projects = current_user.projects
  end

  def new
    @project = Project.new
  end

  def create
    # project does not take a user id on create because the association is stored in the user_join_projects join table
    @project = Project.find_or_create_by(project_params)
    # .merge({user_id: current_user.id}))
    binding.pry
    redirect_to @project
  end

  def show
    @project = Project.find(params[:id])
    @user = current_user
  end

  def update
  end

  def destroy
  end
end
