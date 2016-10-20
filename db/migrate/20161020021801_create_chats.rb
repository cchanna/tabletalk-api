class CreateChats < ActiveRecord::Migration[5.0]
  def change
    create_table :chats do |t|
      t.references :player, null: false
      t.timestamps
    end
  end
end
