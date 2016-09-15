require 'test_helper'

class AuthTest < ActiveSupport::TestCase
  test "bad google token returns nil" do
    auth = Auth.enticate "badtoken", "google"
    assert auth.nil?
  end

  test "bad provider returns nil" do
    auth = Auth.enticate "123456", "notaprovider"
    assert auth.nil?
  end

  test "new test auth" do
    auth = Auth.enticate SecureRandom.hex(16), "test"
    assert auth.name, "auth should have name"
    assert auth.uid, "auth should have uid"
    assert auth.provider_test?, "provider should be test"
    assert auth.user.nil?, "user should be nil"
  end

  test "valid test auth has user" do
    auth = Auth.enticate auths(:cerisa).uid, "test"
    assert auth.name, "auth should have name"
    assert auth.uid, "auth should have uid"
    assert auth.provider_test?, "provider should be test"
    assert_not_nil auth.user, "user should exist"
  end
end
