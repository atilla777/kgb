class AddLegalityToScannedPort < ActiveRecord::Migration
  def change
    add_column :scanned_ports, :legality, :integer
    add_index :scanned_ports, :legality
  end
end
