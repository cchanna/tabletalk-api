class AddBandolierToBladesCharacters < ActiveRecord::Migration[5.0]
  def change
    add_column :blades_characters, :bandolier1, :integer, limit: 2, null: false, default: 0
    add_column :blades_characters, :bandolier2, :integer, limit: 2, null: false, default: 0
  end
end
