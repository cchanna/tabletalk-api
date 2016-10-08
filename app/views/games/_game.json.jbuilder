me = 0

json.id game.id
json.name game.name
json.type game.game_type
json.players do
  json.array! game.players.each_with_index.to_a do |(player, index)|
    json.name player.name
    json.admin player.admin
    json.id player.id
    if @user && player.user.id == @user.id
      me = index
    end
  end
end
json.maxPlayers game.max_players
json.me me
