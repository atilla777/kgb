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

  def ip_addresses
    self.services.select(:host).distinct.pluck(:host)
  end

  def detected_services
    ScannedPort.where(host: self.ip_addresses).group(:port, :protocol)
  end

end
