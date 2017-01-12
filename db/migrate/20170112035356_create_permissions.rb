class CreatePermissions < ActiveRecord::Migration[5.0]
  def change
    create_table :permissions do |t|
      t.text :value, null: false
    end

    change_table :blades_characters do |t|
      t.references :edit_permission
      t.references :view_permission
    end

    change_table :chats do |t|
      t.references :permission
    end
  end
end
