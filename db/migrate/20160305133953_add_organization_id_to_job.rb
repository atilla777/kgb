class AddOrganizationIdToJob < ActiveRecord::Migration
  def change
    add_reference :jobs, :organization, index: true, foreign_key: true
  end
end
