class CreateBladesCharacterPermissions < ActiveRecord::Migration[5.0]
  def change
    create_table :blades_character_permissions do |t|
      t.references :player, null: false
      t.references :character, null: false
      t.boolean :view, null: false, default: false
      t.boolean :edit, null: false, default: false

      t.timestamps
    end
  end
end
