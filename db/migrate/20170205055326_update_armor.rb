class UpdateArmor < ActiveRecord::Migration[5.0]
  def change
    drop_table :blades_armors
    add_column :blades_characters, :armor_special, :bool, null: false, default: false
  end
end
