class Blades::Armor < ApplicationRecord
  validates :name, presence: true, length: {maximum: 20},
                   uniqueness: {scope: :character_id},
                   exclusion: { in: ["heavy", "armor"]}
  validates :used, inclusion: { in: [true, false] }

  belongs_to :character, class_name: :Character

  def update_with data, as:
    player = as.respond_to?(:id) ? as : Player.find_by(id: as)
    actions = []
    unless character.edit_permission.players.include? player
      return Result.failure "You do not have the required permissions to edit that character", 403
    end
    if data == nil
      action = "deleted #{character.name}'s special armor #{self.name.inspect}"
      self.destroy
      actions.push action
    elsif data.respond_to? :key?
      if data.key? :name
        original = self.name
        self.name = data[:name]
        action = "renamed #{character.name}'s special armor "
        action += "from #{original.inspect} "
        action += "to #{name}"
        actions.push action
      end
      if data.key? :used
        original = self.used
        self.used = data[:used]
        action = ""
        if used
          action = "used #{character.name}'s special armor #{self.name.inspect}"
        else
          action = "cleared #{character.name}'s special armor #{self.name.inspect}"
        end
        actions.push action
      end
    end
    unless save
      return Result.failure errors.messages
    end
    return Result.success actions
  end

  def to_json
    return {
      name: name,
      used: used
    }
  end
end
