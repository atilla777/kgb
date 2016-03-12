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

end
