class CreateQueenKillerCharacters < ActiveRecord::Migration[5.0]
  def change
    create_table :queen_killer_characters do |t|
      t.references :player, null: false
      t.string :name, limit: 255
      t.boolean :dead, null: false, default: false
      t.boolean :killer, null: false, default: false
      t.boolean :worthy, null: false, default: false
      t.boolean :judged, null: false, default: false
      t.boolean :ready, null: false, default: false
      t.timestamps
    end
  end
end
