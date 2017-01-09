class CreateBladesCharacters < ActiveRecord::Migration[5.0]
  def change
    create_table :blades_characters do |t|
      t.string :name, limit: 50, null: false
      t.string :playbook, limit: 20
      t.string :aka, limit: 50
      t.text :look
      t.text :heritage
      t.text :background
      t.text :vice
      t.integer :stress, limit: 2, null: false, default: 0
      t.boolean :healing_unlocked, null: false, default: false
      t.integer :healing_clock, limit: 2, null: false, default: 0
      t.boolean :harm_severe, null: false, default: false
      t.boolean :harm_moderate1, null: false, default: false
      t.boolean :harm_moderate2, null: false, default: false
      t.boolean :harm_lesser1, null: false, default: false
      t.boolean :harm_lesser2, null: false, default: false
      t.boolean :armor_normal, null: false, default: false
      t.boolean :armor_heavy, null: false, default: false
      t.integer :playbook_xp, limit: 2, null: false, default: 0
      t.integer :hunt, limit: 2, null: false, default: 0
      t.integer :study, limit: 2, null: false, default: 0
      t.integer :survey, limit: 2, null: false, default: 0
      t.integer :tinker, limit: 2, null: false, default: 0
      t.integer :finesse, limit: 2, null: false, default: 0
      t.integer :prowl, limit: 2, null: false, default: 0
      t.integer :skirmish, limit: 2, null: false, default: 0
      t.integer :wreck, limit: 2, null: false, default: 0
      t.integer :attune, limit: 2, null: false, default: 0
      t.integer :command, limit: 2, null: false, default: 0
      t.integer :consort, limit: 2, null: false, default: 0
      t.integer :sway, limit: 2, null: false, default: 0
      t.integer :insight_xp, limit: 2, null: false, default: 0
      t.integer :prowess_xp, limit: 2, null: false, default: 0
      t.integer :resolve_xp, limit: 2, null: false, default: 0
      t.integer :coin, limit: 2, null: false, default: 0
      t.integer :stash, limit: 2, null: false, default: 0
      t.integer :load, limit: 2, null: false, default: 3
      t.text :notes
      t.timestamps
    end
  end
end
