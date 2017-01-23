class Permission < ApplicationRecord
  def self.for players:nil, game:nil
    value = nil
    if players
      players = Array(players).flatten
      ids = []
      players.each do |player|
        if player.respond_to? :id
          ids.push player.id.to_s
        else
          ids.push player.to_s
        end
      end
      value = ids.join " "
    elsif game
      id = game.respond_to?(:id) ? game.id : game
      value = "game #{id}"
    else
      return nil
    end
    permission = find_by value: value
    permission = create value: value unless permission
    return permission
  end

  def players
    values = value.split " "

    if values[0] == "game"
      game = Game.find_by id: values[1]
      return nil unless game
      return game.players
    end

    return Player.where(id: values)
  end

  def add player
    id = player.respond_to?(:id) ? player.id : player
    values = value.split(" ").push(id).join(" ")
    unless save
      return Result.failure errors.messages
    end
    return Result.success
  end

  def remove player
    id = player.respond_to(:id) ? player.id : player
    ids = value.split(" ")
    unless ids.delete id
      return Result.failure "That player is not in this permission", 404
    end
    value = ids.join(" ")
    unless save
      return Result.failure errors.messages
    end
    return Result.success
  end

  def to_json
    players.map {|p| p.id}
  end

  def broadcast data
    ApplicationCable::Channel.broadcast data, to: players
  end
end
