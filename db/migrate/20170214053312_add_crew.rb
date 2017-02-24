class AddCrew < ActiveRecord::Migration[5.0]
  def change
    create_table :blades_crews do |t|
      t.references :game, type: :uuid,           null: false
      t.string     :name,                        null: false,                 limit: 50
      t.string     :playbook,                                                 limit: 50
      t.string     :reputation,                                               limit: 50
      t.integer    :rep,                         null: false, default: 0,     limit: 2
      t.boolean    :strong,                      null: false, default: false
      t.integer    :tier,                        null: false, default: 0,     limit: 2
      t.integer    :heat,                        null: false, default: 0,     limit: 2
      t.integer    :wanted_level,                null: false, default: 0,     limit: 2
      t.integer    :coin,                        null: false, default: 0,     limit: 2
      t.integer    :xp,                          null: false, default: 0,     limit: 2
      t.string     :hunting_grounds,                                          limit: 50
      t.text       :hunting_grounds_description
      t.text       :lair
      t.integer    :available_upgrades,          null: false, default: 0,     limit: 2
      t.references :edit_permission,             null: false
      t.references :view_permission,             null: false
      t.timestamps
    end

    create_table :blades_claims do |t|
      t.references :crew,   null: false
      t.integer    :row,    null: false
      t.integer    :column, null: false
      t.timestamps
    end

    create_table :blades_crew_abilities do |t|
      t.references :crew, null: false
      t.string     :name, null: false, limit: 50
      t.timestamps
    end

    create_table :blades_contacts do |t|
      t.references :crew,        null: false
      t.string     :name,        null: false, limit: 50
      t.string     :title,       null: false, limit: 50
      t.text       :description
      t.boolean    :favorite,    null: false, default: false
      t.timestamps
    end

    create_table :blades_crew_upgrades do |t|
      t.references :crew, null: false
      t.string     :name, null: false, limit: 50
      t.timestamps
    end

    create_table :blades_cohorts do |t|
      t.references :crew,     null: false
      t.string     :name,     null: false,                 limit: 50
      t.boolean    :is_gang,  null: false, default: true
      t.string     :kind,     null: false,                 limit: 50
      t.boolean    :weak,     null: false, default: false
      t.boolean    :impaired, null: false, default: false
      t.boolean    :broken,   null: false, default: false
      t.boolean    :armor,    null: false, default: false
      t.string     :flaws,    null: false, default: [],    array: true
      t.string     :edges,    null: false, default: [],    array: true
      t.text       :description
      t.timestamps
    end

    add_column :blades_characters, :crew_id, :integer
  end
end
