require 'test_helper'

class GameFlowsTest < ActionDispatch::IntegrationTest
  setup do
    post '/login', as: :json, headers: {token: auths(:cerisa).uid}
    response = ActiveSupport::JSON.decode @response.body
    @token = response["token"]
  end

  test "create and view new game" do
    get games_path, as: :json, headers: {token: @token}
    response = ActiveSupport::JSON.decode @response.body
    games_count = users(:cerisa).games.length

    game = {
      name: "Test game",
      type: 0,
      player: "Test player"
    }
    post games_path, as: :json, headers: {token: @token}, params: game
    response = ActiveSupport::JSON.decode @response.body
    assert response.key?(:id), "ID should be assigned"
    assert response.key?(:maxPlayers), "Max players should be assigned"
    assert response.key?(:name), "Name should be assigned"
    assert response.key?(:type), "Type should be assigned"
    assert response.key?(:players), "Players should be assigned"
    assert_equal game.name, response.name, "Name should be correct"
    assert_equal game.type, response.type, "Type should be correct"
    assert_equal game.player, response.players[0].name, "Player name should be correct"
    assert_equal users(:cerisa).id, response.players[response.me].user.id, "Me should be me"

    get games_path, as: :json, headers: {token: @token}
    response = ActiveSupport::JSON.decode @response.body
    assert_equal games_count + 1, response.length, "Games count should be one higher"
  end

  test "view games" do
    get games_path, as: :json, headers: {token: @token}
    response = ActiveSupport::JSON.decode @response.body
    assert_equal users(:cerisa).games.length, response.length, "Result count should be correct"
    for game in response
      expected = Game.find_by(id: game.id)
      assert game.key?(:id), "ID should be assigned"
      assert game.key?(:maxPlayers), "Max players should be assigned"
      assert game.key?(:name), "Name should be assigned"
      assert game.key?(:type), "Type should be assigned"
      assert game.key?(:players), "Players should be assigned"
      assert_equal expected.id, game.id, "ID should be correct"
      assert_equal expected.name, game.name, "Name should be correct"
      assert_equal expected.game_type, game.type, "Type should be correct"
      assert_equal expected.players.length, game.players.length, "Players count should be correct"
      assert_equal expected.max_players, game.maxPlayers, "Max players should be correct"
      assert_equal users(:cerisa).id, game.players[game.me].user.id, "Me should be me"
    end
    game = response[0]
  end
end
