class Organization < ActiveRecord::Base

  resourcify

  validates :name, length: {minimum: 3, maximum: 255}
  validates :name, uniqueness: true

  has_many :jobs
  has_many :users
  has_many :scanned_ports
  has_many :services

  def self.beholder_role_name
    :beholder
  end
  
   def current_services
    #organizations_ids = policy_scope(Organization).pluck(:id)
    organizations_ids = OrganizationPolicy::Scope.
      new(UserSession.find.user, Organization).
      resolve.
      pluck(:id)

    ScannedPort.where("scanned_ports.organization_id IN (#{organizations_ids.join(', ')})").
      group(:organiuzation_id, :host_ip, :number, :state, :protocol)
  end

end
