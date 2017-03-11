class DropBladesVeteranCrewAbilities < ActiveRecord::Migration[5.0]
  def change
    add_column :blades_crew_abilities, :veteran, :boolean, null: false, default: false
    Blades::CrewAbility.all.each do |a|
      if a.respond_to? :veteran_ability and a.veteran_ability
        a.update name: a.veteran_ability.name, veteran: true
      end
    end
    drop_table :blades_veteran_crew_abilities
  end
end
