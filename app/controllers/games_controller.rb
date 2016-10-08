class GamesController < ApplicationController
  skip_before_action :require_login, only: [:show]
  include ErrorHelper

  def index
    @games = @user.games
  end

  def create
    name = required params, :name
    game_type = required params, :type
    player = required params, :player
    @game = Game.create name: name, game_type: game_type
    player = Player.create name: player, game: @game, user: @user, admin: true
  end

  def show
    @user = User.authorize request.headers[:token]
    @game = Game.find_by(id: params[:id])
    return not_found unless @game
  end

  def join
    @game = Game.find_by(id: params[:id])
    return not_found unless @game
    player = required params, :player
    player = Player.create name: player, game: @game, user: @user, admin: false
  end
end
