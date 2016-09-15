require 'test_helper'
include ActiveSupport::Testing::TimeHelpers

class LoginFlowsTest < ActionDispatch::IntegrationTest
  test "login and logout" do
    post '/login', as: :json, headers: {token: auths(:cerisa).uid}
    response = ActiveSupport::JSON.decode @response.body
    token = response["token"]
    assert_not_nil response["token"], "Should get token back"
    Rails::logger.debug token
    travel 5.minutes
    post '/logout', as: :json, headers: {token: token}
    assert_response :success, "First logout should succeed"
    post '/logout', as: :json, headers: {token: token}
    assert_response :unauthorized, "Second logout should fail"
  end
end
