class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.string :name
      t.text :description
      t.text :ports
      t.text :hosts
      t.text :options

      t.timestamps null: false
    end
  end
end
