class AddMovesToBladesCharacters < ActiveRecord::Migration[5.0]
  def change
    change_table :blades_characters do |t|
      t.text :special_abilities, array: true, null: false, default: []
    end
  end
end
