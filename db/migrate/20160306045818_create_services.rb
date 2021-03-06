class CreateServices < ActiveRecord::Migration
  def change
    create_table :services do |t|
      t.string :name
      t.references :organization, index: true, foreign_key: true
      t.integer :legality
      t.string :host
      t.integer :port
      t.string :protocol
      t.text :description

      t.timestamps null: false
    end
    add_index :services, :legality
    add_index :services, :host
    add_index :services, :port
    add_index :services, :protocol
  end
end
