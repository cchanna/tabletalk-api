module Blades
  def self.table_name_prefix
    'blades_'
  end

  def self.load player_id
    data = {}
    data['characters'] = Character.load player_id
    return data
  end
end
