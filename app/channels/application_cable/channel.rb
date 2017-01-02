module ApplicationCable
  class Channel < ActionCable::Channel::Base
    def subscribed
      @game = Game.find_by id: params['game_id']
      @player = Player.find_by game: @game, user: current_user
      stop_all_streams
      stream_from @game.id.to_s
      @subscribed = true
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

    def unsubscribed
      stop_all_streams
      @subscribed = false
    end

  protected

    def broadcast(data)
      ActionCable.server.broadcast @game.id.to_s, data
    end
  end
end
