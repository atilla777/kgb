class CreateScannedPorts < ActiveRecord::Migration
  def change
    create_table :scanned_ports do |t|
      t.datetime :job_time
      t.references :organization, index: true, foreign_key: true
      t.string :host
      t.integer :port
      t.string :protocol
      t.string :state
      t.string :service

      t.timestamps null: false
    end
    add_index :scanned_ports, :host
    add_index :scanned_ports, :port
    add_index :scanned_ports, :protocol
    add_index :scanned_ports, :state
    add_index :scanned_ports, :service
  end
end
