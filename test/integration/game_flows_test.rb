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
    assert_not_nil game, "Response should not be nil"
    assert game.key?('id'), "ID should be assigned"
    assert game.key?('maxPlayers'), "Max players should be assigned"
    assert game.key?('name'), "Name should be assigned"
    assert game.key?('type'), "Type should be assigned"
    assert game.key?('players'), "Players should be assigned"
    assert_equal input[:name], game['name'], "Name should be correct"
    assert_equal input[:type], game['type'], "Type should be correct"
    assert_equal input[:player], game['players'][0]['name'], "Player name should be correct"
    assert_equal game['players'][0]['id'], game['me'], "Me should be first player"

    get games_path, as: :json, headers: {token: @token}
    games = ActiveSupport::JSON.decode @response.body
    assert_not_nil games, "Response should not be nil"
    assert_equal games_count + 1, games.length, "Games count should be one higher"
  end

  def validate_game(expected, game)
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
    players = game['players'].clone

    expected.players.order(:created_at).each do |expected_player|
      player = players.shift
      assert player.key?('id'), "Player id should be assigned"
      assert player.key?('name'), "Player name should be assigned"
      assert player.key?('admin'), "Player admin should be assigned"
      assert_equal expected_player.id, player['id'], "Player id should be correct"
      assert_equal expected_player.name, player['name'], "Player name should be correct"
      assert_equal expected_player.admin, player['admin'], "Player admin should be correct"
    end
  end

  test "view games" do
    get games_path, as: :json, headers: {token: @token}
    games = ActiveSupport::JSON.decode @response.body
    assert_not_nil games, "Response should not be nil"
    assert_equal users(:cerisa).games.length, games.length, "Result count should be correct"
    for game in games
      expected = Game.find_by(id: game['id'])
      validate_game(expected, game)
      expected_name = users(:cerisa).players.find_by(game_id: game['id']).name
      assert_equal players(:cerisa).id, game['me'], "Me should be me"
    end
  end

  test "preview, login, and join game" do
    get url_for(games(:other_game)), as: :json
    game = ActiveSupport::JSON.decode @response.body
    assert_not_nil game, "Response should not be nil"
    expected = games(:other_game)
    validate_game(expected, game)
    assert_nil game['me'], "User should not be player in this game"

    get url_for(games(:other_game)), as: :json, headers: {token: @token}
    game = ActiveSupport::JSON.decode @response.body
    assert_not_nil game, "Response should not be nil"
    expected = games(:other_game)
    validate_game(expected, game)
    assert_nil game['me'], "User should not be player in this game"

    new_player_name = 'New player'
    post url_for([:join, games(:other_game)]), as: :json, headers: {
      token: @token
    }, params: {
      player: new_player_name
    }
    game = ActiveSupport::JSON.decode @response.body
    assert_not_nil game, "Response should not be nil"
    expected = games(:other_game).reload
    validate_game(expected, game)
    assert_not_nil game['me'], "User should be player in this game"
  end
end
