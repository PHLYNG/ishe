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
    @project = Project.find_or_create_by(dup_project_params.merge({project_action_date: Time.new()+(7*60*60*24)}))

    # UserJoinProject does not contain User
    check_user_proj_has_user = 0

    # see if this project exists, if it does then...
    if UserJoinProject.exists?(project_id: @project.id)
      # ...check if user Id is already on project
      UserJoinProject.where(project_id: @project.id).each do |user_proj|

        if user_proj.user_id == current_user.id
          check_user_proj_has_user += 1
          break
        end
      end

      # make sure user is not already on project, if user not on project, but project exists, add user to project
      if check_user_proj_has_user == 0
        UserJoinProject.create!({user: current_user, project: @project})
        flash[:success] = "Someone else has already created this Project. Together you can make your community better!"
      end

      # if number of users before save is == 4, new user will be number five, therefore set action date to +1 week after user joins project
      # if UserJoinProject.where(project_id: @project.id).count == 4
      #   @project.project_action_date = Time.new()+(7*60*60*24)
      # end

      # set project complete
      # if Time.now() > UserJoinProject.where(project_id: @project.id).project_action_date
      #   @project.project_complete == true
      # end

    else
      UserJoinProject.create!({user: current_user, project: @project})
      flash[:success] = "You are the first person to create this Project but more people are coming soon to help you build your community!"
    end

    redirect_to @project
  end

  def show
    @project = Project.find(params[:id])
    respond_to do |format|
      format.html
      format.json { render json: @project, status: :created, location: @project }
    end
    @user = current_user
  end

  def update
  end

  def destroy
    proj = Project.find(params[:id])
    ujp = UserJoinProject.where(project_id: proj.id, user_id: current_user.id)
    ujp.delete_all
    proj.delete
    redirect_to current_user
  end

  private

  # def project_params
  #   params.require(:project).permit(:project_type, :street1, :street2, :project_action_date, :project_complete)
  # end

  def dup_project_params
    params.require(:project).permit(:project_type, :image, :street1, :street2)
  end

  # def user_join_project_params
  #   params.require(:user_join_project).permit(:project, :user)
  # end
end
