class CreateVeteranCrewAbilities < ActiveRecord::Migration[5.0]
  def change
    create_table :blades_veteran_crew_abilities do |t|
      t.references :ability, null: false
      t.string :name, null: false
      t.timestamps
    end
  end
end
