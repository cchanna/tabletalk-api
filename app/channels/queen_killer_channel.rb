# Be sure to restart your server when you modify this file. Action Cable runs in an EventMachine loop that does not support auto reloading.

class QueenKillerChannel < ApplicationCable::Channel
  include QueenKiller

  def do args
    args = args.deep_symbolize_keys
    action = args[:what]
    data = args[:data]
    result = nil
    case action
    when 'join'
      result = QueenKiller::Character.join @player
    when 'leave'
      result = QueenKiller::Character.leave @player
    when 'start'
      result = QueenKiller::Session.start @player
    else
      game = QueenKiller::Session.find_by game: @player.game
      result = game.do action.to_sym, data, @player
    end
    return unless result and result.succeeded?
    if result.value[:action] == 'get_role'
      @player.game.players.each do |p|
        character = QueenKiller::Character.find_by player: p
        broadcast({action: 'get_role', data: character.killer, phase: result.value[:data]}, to: p)
      end
      return
    elsif result.value[:action] == 'kissed'
      characters = result.value[:data]
      broadcast({
        action: 'kissed',
        data: {
          id: characters[1].id,
          killer: characters[1].killer,
          worthy: characters[1].worthy
        }}, to: characters[0].player
      )
      broadcast({
          action: 'kissed',
          data: {
            id: characters[0].id,
            killer: characters[0].killer,
            worthy: characters[0].worthy
          }
        },
        to: characters[1].player
      )
      return
    end
    out = result.value
    out[:key] = args[:key]
    broadcast out
  end
end
