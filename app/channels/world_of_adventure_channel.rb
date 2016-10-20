# Be sure to restart your server when you modify this file. Action Cable runs in an EventMachine loop that does not support auto reloading.

ACTIONS = {
  talk: 0,
  roll: 1
}

class WorldOfAdventureChannel < ApplicationCable::Channel

  def subscribed
    @game = Game.find_by id: params['game_id']
    @player = Player.find_by game: @game, user: current_user
    stop_all_streams
    stream_from "world_of_adventure_#{@game.id}"
    @subscribed = true
  end

  def unsubscribed
    stop_all_streams
    @subscribed = false
  end

  def talk(data)
    return unless data.has_key? 'message'
    return unless data.has_key? 'request'
    out = {
      id: rand(0..1000000),
      action: ACTIONS[:talk],
      player: @player.id,
      message: data['message'],
      request: data['request']
    }
    broadcast out
  end

  def roll(data)
    bonus = 0
    if data.has_key? 'bonus'
      bonus = data['bonus']
    end
    return unless data.has_key? 'request'
    result = []
    result.push rand 1..6
    result.push rand 1..6
    out = {
      action: ACTIONS[:roll],
      player: @player.id,
      bonus: bonus,
      result: result,
      request: data['request']
    }
    broadcast out
  end

  private

  def broadcast(data)
    ActionCable.server.broadcast "world_of_adventure_#{@game.id}", data
  end
end
