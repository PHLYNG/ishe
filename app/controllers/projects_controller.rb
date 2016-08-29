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

      # DateTime.now gets current DateTime
      # end of week gets sunday at 23:59:59
      # set to next sunday at 10AM
      # -10.hours because default UTC time
      { project_action_date: DateTime.now.end_of_week + (7.days - 10.hours + 1.second),
        complete_button_after_click: false,
        project_complete: false }))

    # save project if it is unique
    # do not save project if it has been created already
      # if created already, add user to that project
      # add user to project by creating new instance of UserJoinProject with same project id

    if @project.check_project_exists.count > 0
      # check project is an array, if more than one project is similiar, render form to let user choose
      if @project.check_project_exists.count > 1
        # make all projects matching criteria available in view
        @projects = @project.check_project_exists
        @userJP = UserJoinProject.create
        # (ujp_params.merge({user_id: current_user.id}))
      end
      binding.pry
      else
        if @project.streets_are_not_different
          flash[:warning] = "Street names were too similar"
          render 'new'
        else
          @project.save
          if @project.save == false
            render 'new'
          else
            UserJoinProject.create!(user: current_user, project: @project)
            flash[:success] = "First person to create a project gets X baltimore bucks?"
            redirect_to @project
          end
        end #end streets_are_not_different
      end # end Project exist if
    end #end create method

  def show
    @project = Project.find(params[:id])
    respond_to do |format|
      format.html
      format.json { render json: @project, status: :created, location: @project }
    end
    @user = current_user
  end

  def update
    @project = Project.find(params[:id])
    @project.project_complete = true
    @project.complete_button_after_click = true
    @project.save
    redirect_to @project
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

  # def ujp_params
  #   params.require(:project).permit(:project_id)
  # end
end
