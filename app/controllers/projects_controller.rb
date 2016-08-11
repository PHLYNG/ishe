class ProjectsController < ApplicationController
  def index
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

          @userJP = UserJoinProject.new(
            user_id: current_user.id,
            project_id: proj.id)

          if @userJP.save
            flash[:success] = "Next person in gets something or no?"
            # if new user on project is 5th user, set new time and then send email with attached calendar date to all users
            if UserJoinProject.where(project: proj).count == 2
              @project.project_action_date = Time.new()+(7*60*60*24)

              @users = []
              UserJoinProject.where(project: proj).each{ |ujp| @users.push(ujp.user.email) }
              UserMailer.start_project(@users, proj).deliver
              # if a new user joins, keep the same time and only send that user an email
            elsif UserJoinProject.where(project: proj).count > 2
              UserMailer.new_user_on_project(current_user, proj).deliver
            end
            redirect_to proj
          else
            flash[:danger] = "You are already working on this project, now go do it!"
            render 'new'
          end



      elsif Project.exists?(
              project_type: @project.project_type,
              street1: @project.street2,
              street2: @project.street1)
        # if project does exists/is true

          proj = Project.find_by(
                        project_type: @project.project_type,
                        street1: @project.street2,
                        street2: @project.street1)

          @userJP = UserJoinProject.new(
            user_id: current_user.id,
            project_id: proj.id)

          if @userJP.save
            flash[:success] = "Next person in gets something or no?"

            if UserJoinProject.where(project: proj).count == 2


              @project.project_action_date = Time.new()+(7*60*60*24)

              @users = []
              UserJoinProject.where(project: proj).each{ |ujp| @users.push(ujp.user) }
              UserMailer.start_project(@users, proj).deliver
              # if a new user joins, keep the same time and only send that user an email
            elsif UserJoinProject.where(project: proj).count > 2
              UserMailer.new_user_on_project(current_user, proj).deliver
            end
            redirect_to proj
          else
            flash[:danger] = "You are already working on this project, now go do it!"
            render 'new'
          end

      # if project does not exist
      else
        @project.save
        UserJoinProject.create!(user: current_user, project: @project)
        flash[:success] = "First person to create a project gets X baltimore bucks?"
        redirect_to @project

      # if creating a new ujp, and it is 5th user, get all users on ujp
      # if number of users before save is == 4, new user will be number five, therefore set action date to +1 week after user joins project
      # if UserJoinProject.where(project_id: @project.id).count == 4
      #   @project.project_action_date = Time.new()+(7*60*60*24)
      end

      # set project complete
      # if Time.now() > UserJoinProject.where(project_id: @project.id).project_action_date
      #   @project.project_complete == true
      # end

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
    # problem with deleting
    # a project "lives" on a user account
    # if a user deletes a project, then all the UJPs need to be deleted or the ones that are left won't be related to a project
    # solution - projects need to "live" somewhere else, but how?
    @project = Project.find(params[:id])
    if @project.user_join_projects.count < 2
      @ujp = UserJoinProject.where(project_id: @project.id, user_id: current_user.id)
      @ujp.delete_all
      @project.delete
    else
      flash[:warning] = "More than one person is working on this Project, therefore the Project cannot be deleted."
    end
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
