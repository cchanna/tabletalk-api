class Chat < ApplicationRecord
  belongs_to :player
  belongs_to :permission
  has_one :talk, dependent: :destroy
  has_one :roll, dependent: :destroy
  has_one :log, dependent: :destroy

  def self.roll(args)
    player = args[:player]
    return nil unless player
    dice = args[:dice]
    return nil unless dice
    bonus = args[:bonus]
    permission = Permission.for game: player.game
    chat = Chat.create player: player, permission: permission
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
    permission = Permission.for game: player.game
    chat = Chat.create player: player, permission: permission
    return nil unless chat
    chat.talk = Talk.create chat: chat, message: message
    return nil unless chat.talk
    return chat
  end

  def self.log(player:, message:, permission:)
    chat = Chat.new player: player, permission: permission
    chat.save!
    chat.log = Log.new chat: chat, message: message
    chat.log.save!
    chat.log.broadcast
  end

  def self.to_json chats
    chats = Array chats
    result = []
    chats.each do |chat|
      if chat and chat.log
        result.push chat.log.to_json
      end
    end
    return result
  end
end
