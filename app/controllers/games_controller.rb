class GamesController < ApplicationController
  skip_before_action :require_login, only: [:show]
  include ErrorHelper

  def index
    @games = @user.games.order(:name)
  end

  def create
    name = required params, :name
    game_type = required params, :type
    player = required params, :player
    @game = Game.create name: name, game_type: game_type
    player = Player.create name: player, game: @game, user: @user, admin: true
  end

  def show
    if request.headers.key? :token
      require_login
    end
    @game = Game.find_by(id: params[:id])
    return not_found unless @game
  end

  def join
    @game = Game.find_by id: params[:id]
    return not_found unless @game
    player = required params, :player
    data = @game.players.create! name: player, user: @user, admin: false
    out = {
      action: Chat.actions[:join],
      id: data.id,
      name: data.name,
      admin: data.admin
    }
    Channel.broadcast out, from: data.id
  end

  def load
    @game = Game.find_by id: params[:id]
    return not_found unless @game
    player = Player.find_by game: @game, user: @user
    return not_found unless player
    result = player.load
    @data = result.value if result.succeeded?
    @me = player.id
  end
end
