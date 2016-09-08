class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.references :primary_auth, null: false
      t.timestamp :earliest_token_time, null: false
      t.timestamps
    end
  end
end
