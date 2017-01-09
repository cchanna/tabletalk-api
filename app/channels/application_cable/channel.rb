module ApplicationCable
  class Channel < ActionCable::Channel::Base
    def subscribed
      @game = Game.find_by id: params['game_id']
      @player = Player.find_by game: @game, user: current_user
      stop_all_streams
      stream_from @player.id.to_s
      @subscribed = true
    end

    def talk(data)
      return unless data.has_key? 'message'
      return unless data.has_key? 'request'
      chat = Chat.talk player: @player, message: data['message']
      out = {
        id: chat.id,
        action: 'talk',
        player: @player.id,
        message: chat.talk.message,
        request: data['request'],
        timestamp: chat.created_at,
        key: data['key']
      }
      broadcast out
    end

    def unsubscribed
      stop_all_streams
      @subscribed = false
    end

    def self.broadcast data, from:
      game = from.respond_to?(:game) ? from.game : Player.find_by(id: from).game
      game.reload
      players = game.players
      Channel.send data, to: players
    end

    def self.send data, to:
      players = Array to
      players.each do |player|
        id = player.respond_to?(:id) ? player.id : player
        ActionCable.server.broadcast id.to_s, data
      end
    end

  protected

    def broadcast data
      Channel.broadcast data, from: @player
    end
  end
end
