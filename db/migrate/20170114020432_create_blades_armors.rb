class CreateBladesArmors < ActiveRecord::Migration[5.0]
  def change
    create_table :blades_armors do |t|
      t.string :name, null: false, limit: 20
      t.boolean :used, null: false, default: false
      t.references :character, null: false
      t.timestamps
    end
  end
end
