class Organization < ActiveRecord::Base
  resourcify

  validates :name, length: {minimum: 3, maximum: 255}
  validates :name, uniqueness: true
  has_many :jobs, dependent: :destroy
  has_many :users, dependent: :destroy
  has_many :scanned_ports, dependent: :destroy
  has_many :services, dependent: :destroy

  def self.beholder_role_name
    :beholder
  end

  def ip_addresses
    services.select(:host).distinct.pluck(:host)
  end

  def detected_services(user)
    jobs_ids = JobPolicy::Scope.new(user, Job).resolve.pluck(:id)
    ScannedPort.where(host: ip_addresses)
               .where(job_id: jobs_ids)
               .where(state: ['filtered', 'open', 'open|filtered'])
               .joins(%q(
                       INNER JOIN (SELECT scanned_ports.job_id,
                       MAX(scanned_ports.job_time)
                       AS 'max_time' FROM scanned_ports
                       GROUP BY scanned_ports.job_id)a
                       ON a.job_id = scanned_ports.job_id
                       AND a.max_time = scanned_ports.job_time
                      )
                     )
               .group(:port, :protocol, :host)
  end
end
