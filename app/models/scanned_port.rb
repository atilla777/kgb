class ScannedPort < ActiveRecord::Base

  belongs_to :organization
  belongs_to :job

  validates :job_id, numericality: {only_integer: true}
  validates :organization_id, numericality: {only_integer: true}

end
