require 'test_helper'
include ActiveSupport::Testing::TimeHelpers

class TokenTest < ActiveSupport::TestCase
  test "create and validate token" do
    auth = User.login 1, "test"
    token = Token.create_from auth
    assert token, 'token should exist'
    user = Token.validate token
    assert_not_nil user, 'should get user from token'
  end

  test "expired token should fail" do
    auth = User.login 1, "test"
    token = Token.create_from auth
    travel 7.days
    user = Token.validate token
    assert_nil user, 'token should be invalid'
  end

  test "logged out user should not validate" do
    auth = User.login 1, "test"
    token = Token.create_from auth
    travel 1.minute
    auth.user.logout
    user = Token.validate token
    assert_nil user, 'token should be invald'
  end
end
