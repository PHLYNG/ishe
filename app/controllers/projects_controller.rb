class ProjectsController < ApplicationController
  def index
    # need to test if using current_user here works, currently defined in SessionsHelper. May need to define current_user in projects helper? But helpers are used only in views, define in model?
    @projects = current_user.projects
    @user = current_user
    respond_to do |format|
      format.html
      format.json { render json: [@user, @projects], status: :created, location: @projects }
    end
  end

  def new
    @project = Project.new
  end

  def create
    # if project doesn't exist create project, if it does take user to that project

    # creating with dup_project_params, which doesn't include action date and complete? Problem?
    # find_or_create_by can't do image uploads?
    # @project = Project.find_or_create_by(
    #                     dup_project_params.merge(
    #                     { project_action_date: Time.new()+(7*60*60*24),
    #                       project_complete: false }))

    # new project first for file upload
    @project = Project.new( project_params_with_image_up.merge(
                          { project_action_date: Time.new()+(7*60*60*24),
                            project_complete: false }))

    # save project if it is unique
    # do not save project if it has been created already
      # if created already, add user to that project
      # add user to project by creating new instance of UserJoinProject with same project id

      # determine if project exists already, flipping around streets
      # need to do elsif because of new UserJoinProject
      if Project.exists?( project_type: @project.project_type, street1: @project.street1,
                          street2: @project.street2)
        UserJoinProject.create!( user_id: current_user.id,
                                project_id: Project.find_by(
                                                    project_type: @project.project_type,
                                                    street1: @project.street1,
                                                    street2: @project.street2).id)

      elsif Project.exists?(project_type: @project.project_type, street1: @project.street2, street2: @project.street1)
        # if project does exists/is true
        UserJoinProject.create!(
          user_id: current_user.id,
          project_id: Project.find_by(
                              project_type: @project.project_type,
                              street1: @project.street2,
                              street2: @project.street1).id)
      # if project does not exist
      else
        @project.save


    # UserJoinProject does not contain User
    # check_user_proj_has_user = 0

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

  def project_params_with_image_up
    params.require(:project).permit(:project_type, :street1, :street2, :photo)
  end

  def dup_project_params
    params.require(:project).permit(:project_type, :image, :street1, :street2)
  end
end
