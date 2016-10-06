require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "login without token" do
    post '/login', as: :json
    assert_response :unauthorized, "should return unauthorized"
    assert_template :auth_error, "should render auth_error template"
  end

  test "valid login with existing user" do
    post '/login', as: :json, headers: {token: auths(:cerisa).uid}
    assert_response :success, "should be successful"
    assert_template :login, "should render login template"
    assert_not_nil assigns(:auth), "auth should exist"
    assert_not_nil assigns(:token), "token should exist"
  end

  test "valid login with new user" do
    post '/login', as: :json, headers: {token: SecureRandom.hex(16)}
    assert_response :success, "should be successful"
    assert_template :login, "should render login template"
    assert_not_nil assigns(:auth), "auth should exist"
    assert_not_nil assigns(:token), "token should exist"
  end

  test "invalid google login" do
    post '/login', as: :json, headers: {token: "badtoken"}, params: {provider: "google"}
    assert_response :unauthorized, "should return unauthorized"
    assert_template :auth_error, "should render auth_error template"
  end

  test "logout without auth" do
    post '/logout', as: :json
    assert_response :unauthorized, "should return unauthorized"
    assert_template :auth_error, "should render auth_error template"
  end

  test "logout with bad auth" do
    post '/logout', as: :json, headers: {token: "badtoken"}
    assert_response :unauthorized, "should return unauthorized"
    assert_template :auth_error, "should render auth_error template"
  end

  test "logout with good auth" do
    token = Token.create_from auths(:cerisa)
    post '/logout', as: :json, headers: {token: token}
    assert_response :success, "should be successful"
  end
end
