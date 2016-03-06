class Organization < ActiveRecord::Base

  validates :name, length: {minimum: 3, maximum: 255}
  validates :name, uniqueness: true

  has_many :jobs
  has_many :users
  has_many :scanned_ports
  has_many :services

end
