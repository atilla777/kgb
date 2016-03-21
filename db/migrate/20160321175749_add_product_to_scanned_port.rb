class AddProductToScannedPort < ActiveRecord::Migration
  def change
    add_column :scanned_ports, :product, :string
    add_index :scanned_ports, :product
    add_column :scanned_ports, :product_version, :string
    add_index :scanned_ports, :product_version
    add_column :scanned_ports, :product_extrainfo, :string
    add_index :scanned_ports, :product_extrainfo
  end
end
