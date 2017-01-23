class AddNameCharacterIndexToArmor < ActiveRecord::Migration[5.0]
  def change
    add_index :blades_armors, [:character_id, :name], unique: true
  end
end
