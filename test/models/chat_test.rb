require 'test_helper'

class ChatTest < ActiveSupport::TestCase
  setup do
    @player = players(:cerisa)
  end

  test "chat should roll" do
    chat = Chat.roll dice: [:d6, :d6], bonus: -1, player: @player
    assert chat, "Roll should succeed"
    assert chat.roll, "Chat should have roll"
  end

  test "chat should talk" do
    chat = Chat.talk message: "Hello!", player: @player
    assert chat, "Talk should succeed"
    assert chat.talk, "Chat shoul dhave talk"
  end
end
