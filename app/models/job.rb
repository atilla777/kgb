class Job < ActiveRecord::Base

  belongs_to :organization
  has_many :schedules, dependent: :destroy
  has_many :scanned_ports, dependent: :destroy
  belongs_to :option_set

  validates :name, length: {minimum: 3, maximum: 255}
  validates :name, uniqueness: {scope: :organization_id}
  validates :options, length: {minimum: 3, maximum: 255}, allow_blank: true
  # to do
  #validate :ports, :ports_format
  validates :hosts, presence: true
  # to do
  #validate :hosts_format
  validates :organization_id, numericality: {only_integer: true}
  validates :option_set_id, numericality: {only_integer: true}

  before_save :range1_to_range2

  scope :today_jobs, ->{
    joins(:schedules)
      .merge(Schedule.where('week_day = :week_day OR month_day = :month_day',
                            week_day: Time.now.wday, month_day: Time.now.day))}

  private
  # make range like 192.168.1-16 from range like 192.168.1-192.168.16
  def range1_to_range2
    range = /\A(?<start_ip_d1_3>#{Service.ip4_d1_3_regexp})(?<start_ip_d4>#{Service.ip4_d4_regexp})-(?<end_ip_d1_3>#{Service.ip4_d1_3_regexp})(?<end_ip_d4>#{Service.ip4_d4_regexp})\z/.match(self.hosts)
    if range
      if range[:start_ip_d1_3] == range[:end_ip_d1_3]
        self.hosts = "#{range[:start_ip_d1_3]}#{range[:start_ip_d4]}-#{range[:end_ip_d4]}"
      end
    end
  end
end
