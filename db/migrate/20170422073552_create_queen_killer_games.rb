class CreateQueenKillerGames < ActiveRecord::Migration[5.0]
  def change
    create_table :queen_killer_sessions do |t|
      t.references :game, null: false, type: :uuid
      t.string :phase, limit: 25, null: false, default: 'intro'
      t.timestamp :started
      t.timestamps
    end
  end
end
