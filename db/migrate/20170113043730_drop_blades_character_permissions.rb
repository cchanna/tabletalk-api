class DropBladesCharacterPermissions < ActiveRecord::Migration[5.0]
  def change
    drop_table :blades_character_permissions
  end
end
