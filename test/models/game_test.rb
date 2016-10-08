require 'test_helper'

class GameTest < ActiveSupport::TestCase
  test "name should be required" do
    game = Game.new game_type: 0
    assert_not game.save, "save should fail"
  end

  test "game_type should be required" do
    game = Game.new name: "Test"
    assert_not game.save, "save should fail"
  end

  test "name cannot be empty" do
    game = Game.new name: "", game_type: 0
    assert_not game.save, "save should fail"
  end

  test "name cannot be longer than 25 chars" do
    game = Game.new name: "a" * 26, game_type: 0
    assert_not game.save, "save should fail"
  end

  test "type must be valid" do
    game = Game.new name: "hi", game_type: 1000
    assert_not game.save, "save should fail"
  end

  test "game should save" do
    game = Game.new name: "a" * 25, game_type: 0
    assert game.save, "save should succeed"
  end
end
