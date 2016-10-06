require 'test_helper'

class PlayerTest < ActiveSupport::TestCase
  test "name should be required" do
    player = Player.new
    player.admin = true
    player.game = games(:world_of_adventure)
    player.user = users(:cerisa)

    assert_nil player.save, "save should fail"
  end

  test "admin should be required" do
    player = Player.new
    player.name = "Test"
    player.game = games(:world_of_adventure)
    player.user = users(:cerisa)

    assert_nil player.save, "save should fail"
  end

  test "game should be required" do
    player = Player.new
    player.name = "Test"
    player.admin = false
    player.user = users(:cerisa)

    assert_nil player.save, "save should fail"
  end

  test "user should be required" do
    player = Player.new
    player.name = "Test"
    player.admin = false
    player.game = games(:world_of_adventure)

    assert_nil player.save, "save should fail"
  end

  test "name cannot be longer than 25 characters" do
    player = Player.new
    player.name = "a" * 26
    player.admin = false
    player.game = games(:world_of_adventure)
    player.user = users(:cerisa)

    assert_nil player.save, "save should fail"
  end

  test "name cannot be empty" do
    player = Player.new
    player.name = ""
    player.admin = false
    player.game = games(:world_of_adventure)
    player.user = users(:cerisa)

    assert_nil player.save, "save should fail"
  end

  test "player should save" do
    player = Player.new
    player.name = "a" * 25
    player.admin = true
    player.game = games(:world_of_adventure)
    player.user = users(:cerisa)

    assert_not_nil player.save, "save should succeed"
  end
end
