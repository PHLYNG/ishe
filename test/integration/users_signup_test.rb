require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  # assert that there will be no difference in User.count after posting to users path
  test "user should not be able to create account with invalid params" do
    get signup_path
      assert_no_difference 'User.count' do
        post users_path, params: { user: { name:  "",
                                           email: "user@invalid",
                                           password:              "foo",
                                           password_confirmation: "bar" } }
      end
    # assert that the users/new page will be rendered on invalid submission
    assert_template 'users/new'
    # assert that there will be present a div with id="error_explanation on invalid user submission"
    assert_select 'div#error_explanation'
    # assert that there will be present on invalid create a div with class alert that will display errors
    assert_select 'div.alert'
    # assert that there will be a field within the html form with action="/signup" which is where the form will be posting to
    assert_select 'form[action="/signup"]'
  end

  test "user should be redirected to show page on successful signup" do
    get signup_path
      assert_difference 'User.count', 1 do
        post users_path, params: {
          user: {
          name:                 "Valid User",
          email:        "user@valid.com",
          password:              "foobar",
          password_confirmation: "foobar" } }
    end
    follow_redirect!
    assert_template 'users/show'
    assert_not flash.blank?

  end
end
