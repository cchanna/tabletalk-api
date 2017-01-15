class AddItemsToBladesCharacters < ActiveRecord::Migration[5.0]
  def change
    add_column :blades_characters, :items, :text, array: true, null: false, default: []
  end
end
