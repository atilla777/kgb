class AddJobIdToScannedPort < ActiveRecord::Migration
  def change
    add_reference :scanned_ports, :job, index: true, foreign_key: true
  end
end
