class Roll < ApplicationRecord
  belongs_to :chat
  has_many :dice, dependent: :destroy
  validates :bonus, presence: true, numericality: {only_integer: true}

  def self.roll(args)
    dice = args[:dice]
    return nil unless dice
    bonus = args[:bonus]
    chat = args[:chat]
    return nil unless :chat
    if dice.is_a? Symbol
      dice = [dice]
    end
    roll = Roll.create chat: chat, bonus: bonus
    return nil unless roll
    dice.each do |die|
      Die.roll kind: die, roll: roll
    end
    return roll
  end

  def result
    result = []
    self.dice.each do |die|
      result.push die.result
    end
    return result
  end
end
