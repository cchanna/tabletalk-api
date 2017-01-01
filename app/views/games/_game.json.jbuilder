me = nil

json.id game.id
json.name game.name
json.type game.game_type
json.players do
  json.array! game.players.each do |player|
    json.name player.name
    json.admin player.admin
    json.id player.id
    if @user && player.user_id == @user.id
      me = player.id
    end
  end
end
json.maxPlayers game.max_players
json.me me
