require 'test_helper'

class ProjectCommentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @project = Project.create(project_type: "Pothole", street1: "37.928374", street2: "-72.933752", photo: "/Users/david/Desktop/Pothole.jpg")

    @user = User.create(name: "Example User", email: "example@dave.com", password: "foobar", password_confirmation: "foobar", photo: "/Users/david/gapic.jpg")

    @project_comment = ProjectComment.new(body: "I am a comment", author: @user.name, project: @project)

    # created by rails scaffold
    # @project_comment = project_comments(:one)
  end

  test "should get index" do
    get project_project_comments_url(@project)
    assert_response :success
  end

  test "should get new" do
    get new_project_project_comment_url(@project)
    assert_response :success
  end

  test "should create project_comment" do
    assert_difference('ProjectComment.count') do
      post project_comments_url, params: { project_comment: { author: @project_comment.author, body: @project_comment.body } }
    end

    assert_redirected_to @project
  end

  test "should show project_comment" do
    get project_project_comment_url(@q  project_comment)
    assert_response :success
  end

  test "should get edit" do
    get edit_project_comment_url(@project_comment)
    assert_response :success
  end

  test "should update project_comment" do
    patch project_comment_url(@project_comment), params: { project_comment: { author: @project_comment.author, body: @project_comment.body } }
    assert_redirected_to project_comment_url(@project_comment)
  end

  test "should destroy project_comment" do
    assert_difference('ProjectComment.count', -1) do
      delete project_comment_url(@project_comment)
    end

    assert_redirected_to project_comments_url
  end
end
