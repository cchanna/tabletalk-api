class CreateGames < ActiveRecord::Migration[5.0]
  def change
    enable_extension 'uuid-ossp'
    
    create_table :games, id: :uuid do |t|
      t.string :name, null: false
      t.integer :type, null: false, default: 0
      t.integer :max_players, null: false
      t.timestamps
    end
  end
end
