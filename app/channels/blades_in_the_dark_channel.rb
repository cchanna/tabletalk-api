# Be sure to restart your server when you modify this file. Action Cable runs in an EventMachine loop that does not support auto reloading.

class BladesInTheDarkChannel < ApplicationCable::Channel
  include Blades
  def roll(data)
    level = 0
    if data.key? 'level' and !data['level'].nil?
      level = data['level']
    end
    return unless data.key? 'request'
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
      action: 'roll',
      player: @player.id,
      bonus: level,
      result: chat.roll.result,
      request: data['request'],
      timestamp: chat.created_at,
      key: data['key']
    }
    broadcast out
  end


  def do args
    args = args.deep_symbolize_keys
    what = args[:what].parameterize.underscore.to_sym
    case what
    when :character
      Blades::Character.do args[:data], key: args[:key], as: @player
    when :crew
      Blades::Crew.do args[:data], key: args[:key], as: @player
    end
  end

  def update args
    args = args.deep_symbolize_keys
    return unless args.key? :data
    data = args[:data]
    out = {
      data: {},
      player: @player.id,
      action: 'update',
      key: args[:key]
    }
    permitted_players = []
    if data.key? :character
      return unless data[:character].key? :id
      character = Character.find_by id: data[:character][:id]
      permitted_players = character.view_permission.players
      result = character.update_with data[:character], as: @player
      if result.succeeded?
        out[:data][:character] = data[:character]
      else
        logger.error 'UPDATE FAILED'
        logger.error result.print_errors
        return
      end
    end
    broadcast out, to: permitted_players
  end
end
