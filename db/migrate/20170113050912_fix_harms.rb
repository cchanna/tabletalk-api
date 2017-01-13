class FixHarms < ActiveRecord::Migration[5.0]
  def change
    change_column :blades_characters, :harm_lesser1, :string, limit: 30, null: false, default: ""
    change_column :blades_characters, :harm_lesser2, :string, limit: 30, null: false, default: ""
    change_column :blades_characters, :harm_moderate1, :string, limit: 30, null: false, default: ""
    change_column :blades_characters, :harm_moderate2, :string, limit: 30, null: false, default: ""
    change_column :blades_characters, :harm_severe, :string, limit: 30, null: false, default: ""
  end
end
