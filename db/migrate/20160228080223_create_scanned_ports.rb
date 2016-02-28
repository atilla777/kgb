class CreateScannedPorts < ActiveRecord::Migration
  def change
    create_table :scanned_ports do |t|
      t.datetime :job_time
      t.references :organization, index: true, foreign_key: true
      t.string :host_ip
      t.integer :number
      t.string :protocol
      t.string :state
      t.string :service

      t.timestamps null: false
    end
    add_index :scanned_ports, :host_ip
    add_index :scanned_ports, :number
    add_index :scanned_ports, :protocol
    add_index :scanned_ports, :state
    add_index :scanned_ports, :service
  end
end
