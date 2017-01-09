class Chat < ApplicationRecord
  belongs_to :player
  has_one :talk
  has_one :roll

  def self.roll(args)
    player = args[:player]
    return nil unless player
    dice = args[:dice]
    return nil unless dice
    bonus = args[:bonus]
    chat = Chat.create player: player
    return nil unless chat
    chat.roll = Roll.roll dice: dice, bonus: bonus, chat: chat
    return nil unless chat.roll
    return chat
  end

  def self.talk(args)
    player = args[:player]
    return nil unless player
    message = args[:message]
    return nil unless message
    chat = Chat.create player: player
    return nil unless chat
    chat.talk = Talk.create chat: chat, message: message
    return nil unless chat.talk
    return chat
  end
end
