require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "Example User", email: "example@dave.com", password: "foobar", password_confirmation: "foobar")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = "       "
    assert_not @user.valid?
  end

  test "name should be less than or equal to 50 characters" do
    @user.name = "a" * 51
  end

  test "email should be present" do
    @user.email = "      "
    assert_not @user.valid?
  end

  test "email should be less than or equal to 255 characters" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end

  test "email address should be a valid email address, not just a non-blank string" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email should be rejected as invalid" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "email should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
    # .dup creates a dublicate record with the same attributes
  end

  test "email should be downcased before save" do
    mixed_email = "DAVE@exampLe.cOm"
    # sets initial email
    @user.email = mixed_email
    # set user email equal to mixed email
    @user.save
    # save user, befores_save should kick in
    assert_equal mixed_email.downcase, @user.reload.email
    # assert that initial emailed when downcased is now equal to @user email
  end

  test "password should not be blank" do
    @user.password = @user.password_confirmation = "      "
    assert_not @user.valid?
  end

  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a"*5
    assert_not @user.valid?
  end

  

end
