require 'test_helper'

class ProjectsControllerTest < ActionDispatch::IntegrationTest

  test "should get index" do
    get projects_path
    assert_response :success
  end

  test "should get new" do
    get new_project_path
    assert_response :success
  end

  test "should get create" do
    get projects_path
    assert_response :success
  end

  test "should get update" do
    get project_path
    assert_response :success
  end

  test "should get destroy" do
    get project_path
    assert_response :success
  end

end
