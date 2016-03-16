class Organization < ActiveRecord::Base

  resourcify

  #scope :ip_addresses, ->{services.select(:host_ip).distinct.pluck(:host_ip)}

  validates :name, length: {minimum: 3, maximum: 255}
  validates :name, uniqueness: true

  has_many :jobs
  has_many :users
  has_many :scanned_ports
  has_many :services

  def self.beholder_role_name
    :beholder
  end

  def ip_addresses
    self.services.select(:host_ip).distinct.pluck(:host_ip)
  end

  def detected_services
    #organization_ips = self.services.select(:host_ip).distinct.pluck(:host_ip)
    ScannedPort.where(host_ip: self.ip_addresses).group(:number)#"host_ip IN (#{self.ip_addresses.join(', ')})")
    #group(:host_ip)
    #organizations_ids = policy_scope(Organization).pluck(:id)
    #organizations_ids = OrganizationPolicy::Scope.
    #  new(UserSession.find.user, Organization).
    #  resolve.
    #  pluck(:id)
    #
    #ScannedPort.where("scanned_ports.organization_id IN (#{organizations_ids.join(', ')})").
    #  group(:organiuzation_id, :host_ip, :number, :state, :protocol)
  end

end
