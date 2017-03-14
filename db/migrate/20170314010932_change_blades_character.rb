class ChangeBladesCharacter < ActiveRecord::Migration[5.0]
  def up
    create_table :blades_character_abilities do |t|
      t.references :character, null: false
      t.string :name, null: false
      t.boolean :veteran, null: false, default: false
      t.timestamps
    end

    Blades::Character.all.each do |c|
      if c.respond_to? :special_abilities and c.respond_to? :abilities and Blades::CharacterAbility
        c.special_abilities.each do |a|
          pb = Blades::CharacterAbility.playbook_abilities[c.playbook]
          if pb
            if pb.include? a
              c.abilities.create name: a
            else
              c.abilities.create name: a, veteran: true
            end
          else
            c.abilities.create name: a
          end
        end
      end
    end

    remove_column :blades_characters, :special_abilities
  end

  def down
    add_column :blades_characters, :special_abilities, :text, array: true, null: false, default: []

    Blades::Character.all.each do |c|
      if c.respond_to? :special_abilities and c.respond_to? :abilities and Blades::CharacterAbility
        c.abilities.each do |a|
          c.special_abilities.push a.name
        end
        c.save
      end
    end

    drop_table :blades_character_abilities
  end
end
