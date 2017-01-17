class CreateBladesStrangeFriends < ActiveRecord::Migration[5.0]
  def change
    create_table :blades_strange_friends do |t|
      t.string :name, limit: "50", null: false
      t.string :title, limit: "50", null: false
      t.text :description
      t.boolean :is_friend
      t.references :character
      t.timestamps
    end
  end
end
