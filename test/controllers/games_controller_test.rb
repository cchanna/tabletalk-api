require 'test_helper'

class GamesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @token = Token.create_from auths(:cerisa)
  end

  test "index should require auth" do
    get games_path, as: :json
    assert_response :unauthorized, "should return unauthorized"
    assert_template :auth_error, "should render auth_error template"
  end

  test "should get index" do
    get games_path, as: :json, headers: {token: @token}
    assert_response :success, "should be successful"
    assert_template :index, "should render index template"
    assert_not_nil assigns(:games), "games should exist"
  end

  test "create should require auth" do
    post games_path, as: :json, params: {
      name: 'test',
      type: 0,
      player: 'hello'
    }
    assert_response :unauthorized, "should return unauthorized"
    assert_template :auth_error, "should render auth_error template"
  end

  test "name should be required for create" do
    post games_path, as: :json, headers: {token: @token}, params: {
      type: 0,
      player: 'hello'
    }
    assert_response :bad_request, "should return bad request"
    assert_not_nil assigns(:param), "should assigned required param"
    assert_template :required_param, "should render required_param template"
  end

  test "type should be required for create" do
    post games_path, as: :json, headers: {token: @token}, params: {
      name: 'test',
      player: 'hello'
    }
    assert_response :bad_request, "should return bad request"
    assert_not_nil assigns(:param), "should assigned required param"
    assert_template :required_param, "should render required_param template"
  end

  test "player should be required for create" do
    post games_path, as: :json, headers: {token: @token}, params: {
      name: 'test',
      type: 0
    }
    assert_response :bad_request, "should return bad request"
    assert_not_nil assigns(:param), "should assigned required param"
    assert_template :required_param, "should render required_param template"
  end

  test "should create game" do
    post games_path, as: :json, headers: {token: @token}, params: {
      name: 'test',
      type: 0,
      player: 'hello'
    }
    assert_response :success, "should be successful"
    assert_template :create, "should render create template"
    assert_not_nil assigns(:game), "game should be assigned"
  end

  test "should show game" do
    get url_for(games(:world_of_adventure)), as: :json
    assert_response :success, "should be successful"
    assert_template :show, "should render show template"
    assert_not_nil assigns(:game), "game should be assigned"
  end

  test "show should return 404" do
    get game_path('badgameid'), as: :json
    assert_response :not_found, "should return not found"
    assert_template :not_found
  end

  test "should join game" do
    post url_for([:join, games(:world_of_adventure)]), as: :json, headers: {
      token: @token
    }
    assert_response :success, "should be successful"
    assert_template :join, "should render join template"
    assert_not_nil assigns(:game), "game should be assigned"
  end

  test "join should require auth" do
    post url_for([:join, games(:world_of_adventure)])
    assert_response :unauthorized, "should return unauthorized"
    assert_template :auth_error, "should render auth_error template"
  end
end
