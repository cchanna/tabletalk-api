class CreatePlayers < ActiveRecord::Migration[5.0]
  def change
    create_table :players do |t|
      t.references :user
      t.references :game, type: :uuid
      t.string :name
      t.boolean :admin
      t.timestamps
    end
  end
end
