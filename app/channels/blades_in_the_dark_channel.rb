# Be sure to restart your server when you modify this file. Action Cable runs in an EventMachine loop that does not support auto reloading.

class BladesInTheDarkChannel < ApplicationCable::Channel

  def subscribed
    @game = Game.find_by id: params['game_id']
    @player = Player.find_by game: @game, user: current_user
    stop_all_streams
    stream_from "blades_in_the_dark_#{@game.id}"
    @subscribed = true
  end

  def unsubscribed
    stop_all_streams
    @subscribed = false
  end

  def talk(data)
    return unless data.has_key? 'message'
    return unless data.has_key? 'request'
    chat = Chat.talk player: @player, message: data['message']
    out = {
      id: chat.id,
      action: Chat.actions[:talk],
      player: @player.id,
      message: chat.talk.message,
      request: data['request'],
      timestamp: chat.created_at
    }
    broadcast out
  end

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

  private

  def broadcast(data)
    ActionCable.server.broadcast "blades_in_the_dark_#{@game.id}", data
  end
end
