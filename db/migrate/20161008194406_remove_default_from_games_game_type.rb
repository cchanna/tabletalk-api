class RemoveDefaultFromGamesGameType < ActiveRecord::Migration[5.0]
  def up
    change_column_default(:games, :game_type, nil)
  end
  def down
    change_column_default(:games, :game_type, 0)
  end
end
