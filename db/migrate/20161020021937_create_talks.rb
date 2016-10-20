class CreateTalks < ActiveRecord::Migration[5.0]
  def change
    create_table :talks do |t|
      t.references :chat, null: false
      t.string :message, null: false
      t.timestamps
    end
  end
end
