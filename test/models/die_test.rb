require 'test_helper'

class DieTest < ActiveSupport::TestCase
  setup do
    @player = players(:cerisa)
    @chat = Chat.create player: @player
    @roll = Roll.create chat: @chat
  end

  test 'kind is required' do
    die = Die.new roll: @roll, result: 1
    assert_not die.save, "Save should fail"
  end

  test 'result is required' do
    die = Die.new roll: @roll, kind: :d6
    assert_not die.save, "Save should fail"
  end

  test 'roll is required' do
    die = Die.new kind: :d6, result: 2
    assert_not die.save, "Save should fail"
  end

  test 'invalid kind is not allowed' do
    die = Die.new roll: @roll, kind: :wat, result: 1
    assert_not die.save, "Save should fail"
  end

  test 'invalid result is not allowed' do
    die = Die.new roll: @roll, kind: :d6, result: 7
    assert_not die.save, "Save should fail"
  end

  test 'valid die should save' do
    die = Die.new roll: @roll, kind: :d6, result: 2
    assert die.save, "Save should succeed"
  end

  test 'roll a die' do
    kind = Die.kinds.to_a[rand 0...Die.kinds.to_a.count][0]
    die = Die.roll roll: @roll, kind: kind
    assert die, "Roll of #{kind} should succeed"
  end
end
