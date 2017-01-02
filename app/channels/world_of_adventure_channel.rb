# Be sure to restart your server when you modify this file. Action Cable runs in an EventMachine loop that does not support auto reloading.

class WorldOfAdventureChannel < ApplicationCable::Channel
  def roll(data)
    bonus = 0
    if data.has_key? 'bonus' and !data['bonus'].nil?
      bonus = data['bonus']
    end
    return unless data.has_key? 'request'
    dice = [:d6, :d6]
    chat = Chat.roll player: @player, dice: dice, bonus: bonus
    out = {
      id: chat.id,
      action: Chat.actions[:roll],
      player: @player.id,
      bonus: bonus,
      result: chat.roll.result,
      request: data['request'],
      timestamp: chat.created_at
    }
    broadcast out
  end
end
