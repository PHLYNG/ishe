class UserJoinProjectsController < ApplicationController

  def index
    @project = Project.find(params[:project_id])
    @ujps = @project.user_join_projects
    respond_to do |format|
      format.html
      format.json { render json: [@project, @ujps], status: :ok, location: @project }
    end
  end

  def new
  end

  def create
    @project = Project.find(params[:project_id])
    @userJP = UserJoinProject.create!(user_join_project_params.merge({ user: current_user, project: @project }))
    binding.pry
    # can't really move to model
    if @userJP.save
      # UserJoinProject must be unique (user on project)
      flash[:success] = "Next person in gets something or no?"
      # if new user on project is 5th user, set new time and then send email with attached calendar date to all users
      if UserJoinProject.where(project: @project).count == 2
        @project.project_action_date = DateTime.now.end_of_week + (7.days - 14.hours + 1.second)

        @users = []
        UserJoinProject.where(project: proj).each{ |ujp| @users.push(ujp.user.email) }
        UserMailer.start_project(@users, proj).deliver
        # if a new user joins, keep the same time and only send that user an email
      elsif UserJoinProject.where(project: @project).count > 2
        UserMailer.new_user_on_project(current_user, proj).deliver
      end # UJP.where
      redirect_to @project

      # if .save fails on ujp
    else
      # @project.user_join_projects.each do |proj|
      # if proj.user_id == current_user.id
      flash[:danger] = "You are already on this project!"
      redirect_to @project
    end #close if
  end #close method

  def save
  end

  def delete
  end

  private
  def user_join_project_params
    params.require(:user_join_project).permit(:project, :user)
  end

end
