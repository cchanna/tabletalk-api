class GamesController < ApplicationController
  include ErrorHelper

  def index
    @games = @user.games 
  end

  def create
    name = required params, :name
    game_type = required params, :type
    player = required params, :player
    @game = Game.create name: name, game_type: game_type
    player = Player.create name: player, game: @game, user: @user
  end
end
