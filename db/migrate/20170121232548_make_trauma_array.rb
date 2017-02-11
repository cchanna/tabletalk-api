class MakeTraumaArray < ActiveRecord::Migration[5.0]
  def up
    add_column :blades_characters, :trauma_tmp, :string, array: true, null: false, default: []
    Blades::Character.reset_column_information
    Blades::Character.all.each do |c|
      c.trauma_tmp = c.trauma.split(" ")
      c.save
    end
    remove_column :blades_characters, :trauma
    rename_column :blades_characters, :trauma_tmp, :trauma
  end

  def down
    add_column :blades_characters, :trauma_tmp, :string, null: false, default: ""
    Blades::Character.reset_column_information
    Blades::Character.all.each do |c|
      c.trauma_tmp = c.trauma.join(" ")
      c.save
    end
    remove_column :blades_characters, :trauma
    rename_column :blades_characters, :trauma_tmp, :trauma
  end
end
