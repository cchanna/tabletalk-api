json.players do
  @game.players.each do |player|
    json.set! player.id do
      json.id player.id
      json.name player.name
      json.admin player.admin
    end
  end
end
if @data
  json.data @data
end
json.me @me
