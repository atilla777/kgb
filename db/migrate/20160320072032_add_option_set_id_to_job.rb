class AddOptionSetIdToJob < ActiveRecord::Migration
  def change
    add_column :jobs, :option_set_id, :integer
    add_index :jobs, :option_set_id
  end
end
