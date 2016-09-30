class ProjectsController < ApplicationController
  def index
    if current_user.email == "dcordz@gmail.com"
      @projects = Project.all
      respond_to do |format|
        format.html
        format.json { render :json => @projects.to_json }
      end #end each
    else
      @projects = current_user.projects
      respond_to do |format|
        format.html
        format.json { render json: @projects.to_json }
      end #end each
    end #end if else
  end #end method

  def new
    @project = Project.new
  end

  def create
    # new project first for file upload
    @project = Project.new(project_params_with_image_up.merge(

      # DateTime.now gets current DateTime
      # end of week gets sunday at 23:59:59
      # set to next sunday at 10AM
      # default time set to EST in config application.rb
      { project_action_date: DateTime.now.end_of_week + (7.days - 14.hours + 1.second),
        complete_button_after_click: false,
        project_complete: false } ))

    # save project if it is unique
    # do not save project if it has been created already
      # if created already, add user to that project
      # add user to project by creating new instance of UserJoinProject with same project id
      binding.pry

    if @project.project_exists.count == 1
      @project = @project.project_exists.first
      # UJP validations should check users on projects
      # if @project.check_users
      #   flash[:warning] = "You are already on this Project!"
      #   redirect_to @project
        # project_exists returns an array
        UserJoinProject.create( user: current_user, project: @project )
        redirect_to @project
    elsif @project.project_exists.count > 1
      # make all projects matching criteria available in view
      @projects = @project.project_exists
      # choose project view allows user to choose which project they intended to create so they can join the appropriate project
      render 'choose_project'
    else
      unless @project.save
        render 'projects/new'
      else
        UserJoinProject.create!(user: current_user, project: @project)
        flash[:success] = "First person to create a project gets X baltimore bucks?"
        respond_to do |format|
          format.html { redirect_to @project }
          format.json { render :show, status: :created, location: @project }
        end #end formatting
      end #end UJP create
    end # end Project exist if
  end #end create method

  def show
    @project = Project.find(params[:id])
    unless @project.users.exists?(current_user)
      flash[:danger] = "You must be on a Project in order to view it. Try creating a new Project!"
      redirect_to current_user
    else
    respond_to do |format|
      format.html
      format.json { render json: @project, status: :created, location: @project }
    end
    @user = current_user
    end
  end

  def edit
    @project = Project.find(params[:id])
    unless @project.users.exists?(current_user)
      flash[:danger] = "You can only verify projects that you are a part of!"
      redirect_to current_user
    end
  end

  def update
    @project = Project.find(params[:id])
    if @project.complete_button_after_click == false
      if @project.update(proj_verify)
        flash[:success] = "Congratulations on successfully completing this Project."
        redirect_to @project
      else
        render 'edit'
      end
    else
      flash[:warning] = "This Project has already been marked Complete"
      redirect_to @project
    end
  end

  def destroy
    # problem with deleting
    # a project "lives" on a user account
    # if a user deletes a project, then all the UJPs need to be deleted or the ones that are left won't be related to a project
    # solution - projects need to "live" somewhere else, but how?
    # or maybe this isn't a problem, one user shouldn't be able to delete a project that everyone is working on, only one that they've created and no one else is doing
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

  def proj_verify
    params.require(:project).permit(:street1, :street2, :photo, :verify_photo)
  end
end
