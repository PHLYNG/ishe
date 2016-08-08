require 'test_helper'

class ProjectCreationTest < ActionDispatch::IntegrationTest
  test "a project should only be created once and the UserJoinProject associated with it should have unique users" do
    get new_project_path
    assert_template 'projects/new'
    # create two projects with similar params, count of all projects should only increase by 1
    assert_difference 'Project.count', count: 1 do
      post projects_path params: { project: {
        project_type: "Pothole",
        street1: "A St.",
        street2: "B St."
      }}
      post projects_path params: { project: {
        project_type: "Pothole",
        street1: "A St.",
        street2: "B St."
      }}
    end

    # redirect to new project or found project
    assert_template 'projects/show'



  end
end
