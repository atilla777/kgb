class Job < ActiveRecord::Base
  belongs_to :organization
  has_many :schedules, dependent: :destroy
  has_many :scanned_ports, dependent: :destroy
  belongs_to :option_set

  validates :name, length: {minimum: 3, maximum: 255}
  validates :name, uniqueness: {scope: :organization_id}
  validates :options, length: {minimum: 3, maximum: 255}, allow_blank: true
  validate :ports, :ports_format
  validates :hosts, presence: true
  validate :hosts_format
  validates :organization_id, numericality: {only_integer: true}
  validates :option_set_id, numericality: {only_integer: true}

  before_save :range1_to_range2

  scope :today_jobs, ->{
    joins(:schedules)
      .merge(Schedule.where('week_day = :week_day OR month_day = :month_day',
                            week_day: Time.now.wday, month_day: Time.now.day))}

  private
  # check port range like '21' or '80-123' or '110; 21-25;'
  def ports_format
    error = false
    ports.split(';').each do |port_range|
      ports_list = port_range.split('-')
      if ports_list.length > 2
          error = true
      elsif ports_list.length == 2
        if ports_list[0].to_i > ports_list[1].to_i
          error = true
        end
      end
      ports_list.each do |port|
        unless /^\s*\d*$\s*/ =~ port
          error = true
        end
        unless (0..65535).cover? port.to_i
          error = true
        end
      end
    end
    if error
      errors[:ports] << I18n.t('errors.messages.must_be_port_or_range')
    end
  end

  def hosts_format
    hosts_list = hosts.split(';')
    hosts_list.each do |host|
      dns_name =  /^\s*#{Service.dns_name_regexp}\s*$/ =~ host
      range = /^\s*(?<start_ip>#{Service.ip4_regexp})-(?<end_ip>#{Service.ip4_regexp})\s*$/ =~ host
      range2 = /^\s*(?<start_ip_d1_3>#{Service.ip4_d1_3_regexp})(?<start_ip_d4>#{Service.ip4_d4_regexp})-(?<end_ip_d4>#{Service.ip4_d4_regexp})\s*$/ =~ host
      range3 = /^\s*(?<start_ip>#{Service.ip4_d1_3_regexp})\*\s*$/ =~ host
      unless /^\s*#{Service.ip4_regexp}\s*$/ =~ host || range || range2 || range3 || dns_name
        errors[:hosts] << I18n.t('errors.messages.must_be_ip4_or_range')
      end
    end
  end

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
