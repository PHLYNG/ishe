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
      if Project.exists?(
          project_type: @project.project_type,
          street1: @project.street1,
          street2: @project.street2)

          proj = Project.find_by(
                        project_type: @project.project_type,
                        street1: @project.street1,
                        street2: @project.street2)

          UserJoinProject.create!(
            user_id: current_user.id,
            project_id: proj.id)

          flash[:success] = "Next person in gets something or no?"
          redirect_to proj

      elsif Project.exists?(
              project_type: @project.project_type,
              street1: @project.street2,
              street2: @project.street1)
        # if project does exists/is true

          proj = Project.find_by(
                        project_type: @project.project_type,
                        street1: @project.street2,
                        street2: @project.street1)

              UserJoinProject.create!(
                user_id: current_user.id,
                project_id: proj.id)

          flash[:success] = "Next person in gets something or no?"
          redirect_to proj

      # if project does not exist
      else
        @project.save
        UserJoinProject.create!(user: current_user, project: @project)
        flash[:success] = "First person to create a project gets X baltimore bucks?"
        redirect_to @project

      # if number of users before save is == 4, new user will be number five, therefore set action date to +1 week after user joins project
      # if UserJoinProject.where(project_id: @project.id).count == 4
      #   @project.project_action_date = Time.new()+(7*60*60*24)
      # end

      # set project complete
      # if Time.now() > UserJoinProject.where(project_id: @project.id).project_action_date
      #   @project.project_complete == true
      # end
    end
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

  # def dup_project_params
  #   params.require(:project).permit(:project_type, :image, :street1, :street2)
  # end
end
