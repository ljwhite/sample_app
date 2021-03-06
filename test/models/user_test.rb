require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(
      name: "Example User",
      email: "user@example.com",
      password: 'password',
      password_confirmation: 'password')
  end

  test 'should be valid' do
    assert @user.valid?
  end

  test 'name should be present' do
    @user.name = "     "
    assert_not @user.valid?
  end

  test 'email should be present' do
    @user.email = "     "
    assert_not @user.valid?
  end

  test 'name should not be too long' do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test 'email should not be too long' do
    @user.email = "a" * 256
    assert_not @user.valid?
  end

  test 'email validation should accept valid addresses' do
    valid_addresses = %w[user@example.com USER@foo.com                  A_US@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |address|
      @user.email = address
      assert @user.valid?, "Address #{address.inspect} should be valid"
    end
  end

  test 'email valdation should reject invalid email addresses' do
    invalid_address = %w[user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com]
    invalid_address.each do |address|
      @user.email = address
      assert_not @user.valid?, "Address #{address.inspect} should be invalid"
    end
  end

  test 'email address should be unique' do
    @user.save
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    duplicate_user.save
    assert_not duplicate_user.valid?
  end

  test 'email should be downcased prior to save' do
    @user.email = "EMAIL@EMAIL.COM"
    assert_equal "EMAIL@EMAIL.COM", @user.email
    @user.save
    assert_equal "email@email.com", @user.email
  end

  test 'password should be present (nonblank)' do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  test 'password should have a minimum length' do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

end
