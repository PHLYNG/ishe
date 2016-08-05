require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  test "flash should render only on login page upon unsucessful login" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: {
      session: {
        email: 'invalid.email',
        password: 'almos' }}
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end
end
