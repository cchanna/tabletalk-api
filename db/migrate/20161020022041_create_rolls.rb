class CreateRolls < ActiveRecord::Migration[5.0]
  def change
    create_table :rolls do |t|
      t.references :chat, null: false
      t.integer :bonus, null: false, default: 0
      t.timestamps
    end
  end
end
