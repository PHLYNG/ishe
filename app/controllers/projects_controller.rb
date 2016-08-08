class ProjectsController < ApplicationController
  def index
    # need to test if using current_user here works, currently defined in SessionsHelper. May need to define current_user in projects helper? But helpers are used only in views, define in model?
    @projects = current_user.projects
  end

  def new
    @project = Project.new


  end

  def create
    # if project doesn't exist create project, if it does take user to that project

    # creating with dup_project_params, which doesn't include action date and complete? Problem?
    binding.pry
    @project = Project.find_or_create_by(dup_project_params)

    # UserJoinProject does not contain User
    check_user_proj_has_user = 0
    if UserJoinProject.exists?(project_id: @project.id)
      UserJoinProject.where(project_id: @project.id).each do |user_proj|

        if user_proj.user_id == current_user.id
          check_user_proj_has_user += 1
          break
        end
      end

      if check_user_proj_has_user == 0
        UserJoinProject.create!({user: current_user, project: @project})
        flash[:success] = "Someone else has already created this Project. Together you can make your community better!"
      end

    else
      UserJoinProject.create!({user: current_user, project: @project})
      flash[:success] = "You are the first person to create this Project but more people are coming soon to help you build your community!"
    end

    redirect_to @project
  end

  def show
    @project = Project.find(params[:id])
    @user = current_user
  end

  def update
  end

  def destroy
    # proj = Project.find(params[:id])
    # ujp = UserJoinProject.where(project_id: proj.id)
    # ujp.delete_all
    # proj.delete
    redirect_to current_user
  end

  private

  # def project_params
  #   params.require(:project).permit(:project_type, :street1, :street2, :project_action_date, :project_complete)
  # end

  def dup_project_params
    params.require(:project).permit(:project_type, :street1, :street2)
  end

  # def user_join_project_params
  #   params.require(:user_join_project).permit(:project, :user)
  # end
end
