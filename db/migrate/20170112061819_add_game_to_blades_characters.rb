class AddGameToBladesCharacters < ActiveRecord::Migration[5.0]
  def up
    change_table :blades_characters do |t|
      t.references :game, type: :uuid
    end

    Blades::Character.all.each do |c|
      c.update(game_id: Game.first.id)
    end

    change_column_null :blades_characters, :game_id, false
  end

  def down
    remove_column :blades_characters, :game_id
  end
end
