class CreateQueenKillerKisses < ActiveRecord::Migration[5.0]
  def change
    create_table :queen_killer_kisses do |t|
      t.references :suitor, null: false
      t.references :love, null: false
      t.boolean :accepted, null: false, default: false
      t.timestamps
    end
  end
end
