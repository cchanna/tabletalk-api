require 'test_helper'

class GameFlowsTest < ActionDispatch::IntegrationTest
  setup do
    post '/login', as: :json, headers: {token: auths(:cerisa).uid}
    response = ActiveSupport::JSON.decode @response.body
    @token = response["token"]
  end

  test "create and view new game" do
    games_count = users(:cerisa).games.length

    input = {
      name: "Test game",
      type: 0,
      player: "Test player"
    }
    post games_path, as: :json, headers: {token: @token}, params: input
    game = ActiveSupport::JSON.decode @response.body
    assert game.key?('id'), "ID should be assigned"
    assert game.key?('maxPlayers'), "Max players should be assigned"
    assert game.key?('name'), "Name should be assigned"
    assert game.key?('type'), "Type should be assigned"
    assert game.key?('players'), "Players should be assigned"
    assert_equal input[:name], game['name'], "Name should be correct"
    assert_equal input[:type], game['type'], "Type should be correct"
    assert_equal input[:player], game['players'][0]['name'], "Player name should be correct"
    assert_equal 0, game['me'], "Me should be 0"

    get games_path, as: :json, headers: {token: @token}
    games = ActiveSupport::JSON.decode @response.body
    assert_equal games_count + 1, response['games'].length, "Games count should be one higher"
  end

  test "view games" do
    get games_path, as: :json, headers: {token: @token}
    games = ActiveSupport::JSON.decode @response.body
    assert_equal users(:cerisa).games.length, games.length, "Result count should be correct"
    for game in games
      expected = Game.find_by(id: game['id'])
      assert game.key?('id'), "ID should be assigned"
      assert game.key?('maxPlayers'), "Max players should be assigned"
      assert game.key?('name'), "Name should be assigned"
      assert game.key?('type'), "Type should be assigned"
      assert game.key?('players'), "Players should be assigned"
      assert_equal expected.id, game['id'], "ID should be correct"
      assert_equal expected.name, game['name'], "Name should be correct"
      assert_equal expected.game_type, game['type'], "Type should be correct"
      assert_equal expected.players.length, game['players'].length, "Players count should be correct"
      assert_equal expected.max_players, game['maxPlayers'], "Max players should be correct"
      expected_name = users(:cerisa).players.find_by(game_id: game['id'])
      assert_equal expected_name, game.players[game.me].name, "Me should be me"
    end
    game = response[0]
  end
end
