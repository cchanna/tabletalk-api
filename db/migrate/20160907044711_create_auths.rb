class CreateAuths < ActiveRecord::Migration[5.0]
  def change
    create_table :auths do |t|
      t.integer :provider, null: false, default: 0
      t.string :uid, null: false
      t.string :name, null: false
      t.references :user
      t.timestamps
    end
    add_index :auths, [:uid, :provider]
  end
end
