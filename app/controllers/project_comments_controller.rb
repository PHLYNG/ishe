class ProjectCommentsController < ApplicationController
  before_action :set_project_comment, only: [:show, :edit, :update, :destroy]

  # GET /project_comments
  def index
    @project = Project.find(params[:project_id])
    @project_comments = @project.project_comments
    respond_to do |format|
      format.html
      format.json { render json: [@project, @project_comments], status: :created, location: @project }
    end
  end

  # GET /project_comments/1
  def show
    @project = Project.find(params[:project_id])
    @project_comment = ProjectComment.find(params[:id])
    respond_to do |format|
      format.html
      format.json { render json: [@project, @project_comment], status: :created, location: @project }
    end
  end

  # GET /project_comments/new
  def new
    @project = Project.find(params[:project_id])
    @project_comment = ProjectComment.new
  end

  # GET /project_comments/1/edit
  def edit
  end

  # POST /project_comments
  def create
    @project = Project.find(params[:project_id])

    @user = @project.user_join_projects.find_by(user_id: current_user.id).user

    @project_comment = ProjectComment.create(project_comment_params.merge({author: @user.name, project: @project}))

    if @project_comment.save
      redirect_to @project, notice: 'Project comment was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /project_comments/1
  def update
    if @project_comment.update(project_comment_params)
      redirect_to @project_comment, notice: 'Project comment was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /project_comments/1
  def destroy
    @project_comment.destroy
    redirect_to project_comments_url, notice: 'Project comment was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project_comment
      @project_comment = ProjectComment.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def project_comment_params
      params.require(:project_comment).permit(:body)
    end
end
