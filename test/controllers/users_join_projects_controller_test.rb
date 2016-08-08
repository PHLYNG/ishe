require 'test_helper'

class UsersJoinProjectsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get users_join_projects_index_url
    assert_response :success
  end

  test "should get new" do
    get users_join_projects_new_url
    assert_response :success
  end

  test "should get create" do
    get users_join_projects_create_url
    assert_response :success
  end

  test "should get save" do
    get users_join_projects_save_url
    assert_response :success
  end

  test "should get delete" do
    get users_join_projects_delete_url
    assert_response :success
  end

end
