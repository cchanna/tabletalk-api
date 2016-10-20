class CreateDice < ActiveRecord::Migration[5.0]
  def change
    create_table :dice do |t|
      t.references :roll, null: false
      t.integer :kind, null: false
      t.integer :result, null: false
      t.timestamps
    end
  end
end
