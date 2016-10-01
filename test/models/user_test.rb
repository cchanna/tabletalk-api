require 'test_helper'
include ActiveSupport::Testing::TimeHelpers

class UserTest < ActiveSupport::TestCase
  test "bad google token returns nil" do
    auth = User.login "badtoken", "google"
    assert auth.nil?
  end

  test "bad provider returns nil" do
    auth = User.login "123456", "notaprovider"
    assert auth.nil?
  end

  test "new user" do
    auth = User.login SecureRandom.hex(16), "test"
    user = auth.user
    assert user, 'user should exist'
    assert auth.user.primary_auth, 'user should have primary auth'
    assert auth.user.earliest_token_time > 1.minute.ago, 'earliest_token_time should be recent'
    assert auth.user.created_at > 1.minute.ago, 'creation date should be recent'
  end

  test "returning user" do
    auth = User.login auths(:cerisa).uid, "test"
    assert auth.user, 'user should exist'
    assert auth.user.primary_auth, 'user should have primary auth'
    assert auth.user.created_at < 1.day.ago, 'creation date should not be recent'
  end

  test "logout" do
    auth = User.login auths(:cerisa).uid, "test"
    travel 7.days
    assert auth.user.earliest_token_time < 1.minute.ago, 'earliest_token_time should not be recent'
    auth.user.logout
    assert auth.user.earliest_token_time > 1.minute.ago, 'earliest_token_time should be recent'
  end
end
