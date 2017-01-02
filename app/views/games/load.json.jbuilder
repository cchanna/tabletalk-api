json.chats do
  json.array! @chats.each do |chat|
    json.id chat.id
    json.player chat.player_id
    json.timestamp chat.created_at.to_f * 1000
    if chat.talk
      json.message chat.talk.message
      json.action Chat.actions[:talk]
    elsif chat.roll
      json.result chat.roll.result
      json.bonus chat.roll.bonus
      json.action Chat.actions[:roll]
    end
  end
end
json.players do
  json.array! @game.players.each do |player|
    json.id player.id
    json.name player.name
    json.admin player.admin
  end
end
