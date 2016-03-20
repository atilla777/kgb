class CreateOptionSets < ActiveRecord::Migration
  def change
    create_table :option_sets do |t|
      t.string :name
      t.string :description
      t.text :options

      t.timestamps null: false
    end
  end
end
