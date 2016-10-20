require 'test_helper'

class RollTest < ActiveSupport::TestCase
  setup do
    @player = players(:cerisa)
    @chat = Chat.create player: @player
  end

  test "bonus should default to 0" do
    roll = Roll.create chat: @chat
    assert roll, "Create should not fail"
    assert_equal 0, roll.bonus
  end

  test "bonus can't be nil" do
    roll = Roll.new chat: @chat, bonus: nil
    assert_not roll.save, "Save should fail"
  end

  test "bonus must be a number" do
    roll = Roll.new chat: @chat, bonus: "WAT"
    assert_not roll.save, "Save should fail"
  end

  test "chat is required" do
    roll = Roll.new
    assert_not roll.save, "Save should fail"
  end

  test "roll should create" do
    roll = Roll.create chat: @chat, bonus: 2
    assert roll, "Create should not fail"
  end

  test "roll some dice" do
    count = rand 1..10
    dice = []
    for i in 0...count
      dice.push Die.kinds.to_a[rand 0...Die.kinds.to_a.count][0]
    end
    bonus = rand -5..5
    roll = Roll.roll dice: dice, bonus: bonus, chat: @chat
    assert roll, "Roll should succeed"
    assert_equal bonus, roll.bonus, "Bonus should be correct"
    assert_equal dice.count, roll.dice.count, "Count of dice should be correct"
    roll.dice do |die|
      assert Die.sides_for(die.kind).include? die.result, "Result for #{die.kind} should be valid"
    end
  end
end
