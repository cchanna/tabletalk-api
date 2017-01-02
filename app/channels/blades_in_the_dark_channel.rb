# Be sure to restart your server when you modify this file. Action Cable runs in an EventMachine loop that does not support auto reloading.

class BladesInTheDarkChannel < ApplicationCable::Channel
  def roll(data)
    level = 0
    if data.has_key? 'level' and !data['level'].nil?
      level = data['level']
    end
    return unless data.has_key? 'request'
    dice = []
    if level == 0
      dice = [:d6, :d6]
    else
      i = 1
      while i <= level do
        dice.push :d6
        i += 1
      end
    end
    chat = Chat.roll player: @player, dice: dice, bonus: level
    out = {
      id: chat.id,
      action: Chat.actions[:roll],
      player: @player.id,
      bonus: level,
      result: chat.roll.result,
      request: data['request'],
      timestamp: chat.created_at
    }
    broadcast out
  end
end
