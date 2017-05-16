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

  before_save :convert_hosts

  scope :today_jobs, ->{
    joins(:schedules)
      .merge(Schedule.where('week_day = :week_day OR month_day = :month_day',
                            week_day: Time.now.wday, month_day: Time.now.day))}
  def run_today?
    Schedule.where('job_id = :job_id AND (week_day = :week_day OR month_day = :month_day)',
                    job_id: self.id, week_day: Time.now.wday, month_day: Time.now.day).first.present?
  end

  def self.find_by_dj_id(delayed_job_id)
    delayed_job = Delayed::Job.where(id: delayed_job_id).first
    if delayed_job.present?
      job_data = YAML.load(delayed_job.handler).job_data
      if job_data['job_class'] == 'ScanJob'
        s = job_data['arguments'][0]['_aj_globalid']
        job_id = /\d+$/.match(s)[0].to_i
        Job.where(id: job_id).first
      end
    end
  end

  private
  # check port range like '21' or '80-123' or '110; 21-25;'
  def ports_format
    err = false
    ports.split(',').each do |port_range|
      ports_list = port_range.split('-')
      if ports_list.length > 2
          err = true
      elsif ports_list.length == 2
        if ports_list[0].to_i > ports_list[1].to_i
          err = true
        end
      end
      ports_list.each do |port|
        unless /^\s*\d*$\s*/ =~ port
          err = true
        end
        unless (0..65535).cover? port.to_i
          err = true
        end
      end
    end
    if err
      errors[:ports] << I18n.t('errors.messages.must_be_port_or_range')
    end
  end

  def hosts_format
    err = false
    hosts_list = hosts.split(';')
    hosts_list.each do |host|
      ip = /^\s*#{Service.ip4_regexp}\s*$/.match(host)
      dns_name =  /^\s*#{Service.dns_name_regexp}\s*$/.match(host)
      # range like 10.1.1.1-1.1.1.2
      range = /^\s*(?<start_ip>#{Service.ip4_regexp})
              -(?<end_ip>#{Service.ip4_regexp})\s*$/x
              .match(host)
      # range like nmap format 10.1.1.1-10
      range2 = /^\s*(?<start_ip_d1_3>#{Service.ip4_d1_3_regexp})
               (?<start_ip_d4>#{Service.ip4_d4_regexp})-
               (?<end_ip_d4>#{Service.ip4_d4_regexp})
               \s*$/x
               .match(host)
      # range like 10.1.1.*
      range3 = /^\s*(?<start_ip>#{Service.ip4_d1_3_regexp})\*\s*$/ =~ host
      if ip || range || range2 || range3 || dns_name
        if range
          err = IPAddr.new(range[:start_ip]).to_i > IPAddr.new(range[:end_ip]).to_i
        elsif range2
          err = range2[:start_ip_d4].to_i > range2[:end_ip_d4].to_i
        end
      else
        err = true
      end
    end
    if err
      errors[:hosts] << I18n.t('errors.messages.must_be_ip4_or_range')
    end
  end

  def convert_hosts
    new_hosts_list = []
    self.hosts.split(';').each do |host|
      range = Service.ip4_range1_regexp.match(host)
      if range
        new_hosts_list << to_nmap_range(range)
      else
        new_hosts_list << host
      end
    end
    self.hosts = new_hosts_list.join(';')
  end

  # make range like 192.168.1-16 (nmap supported format) from range like 192.168.1-192.168.16
  def to_nmap_range(range)
    case
    when d1_3_eq?(range)
      <<-IP.tr(" \n\t", '')
        #{range[:start_ip_d1]}.
        #{range[:start_ip_d2]}.
        #{range[:start_ip_d3]}.
        #{range[:start_ip_d4]}-#{range[:end_ip_d4]}
      IP
    when d1_2_eq?(range)
      <<-IP.tr(" \n\t", '')
        #{range[:start_ip_d1]}.
        #{range[:start_ip_d2]}.
        #{range[:start_ip_d3]}-#{range[:end_ip_d3]}.
        #{range[:start_ip_d4]}-#{range[:end_ip_d4]}
      IP
    when d1_eq?(range)
      <<-IP.tr(" \n\t", '')
        #{range[:start_ip_d1]}.
        #{range[:start_ip_d2]}-#{range[:end_ip_d2]}.
        #{range[:start_ip_d3]}-#{range[:end_ip_d3]}.
        #{range[:start_ip_d4]}-#{range[:end_ip_d4]}
      IP
    end
  end

  def d1_3_eq?(range)
    range[:start_ip_d1] == range[:end_ip_d1] &&
    range[:start_ip_d2] == range[:end_ip_d2] &&
    range[:start_ip_d3] == range[:end_ip_d3]
  end

  def d1_2_eq?(range)
    range[:start_ip_d1] == range[:end_ip_d1] &&
    range[:start_ip_d2] == range[:end_ip_d2]
  end

  def d1_eq?(range)
    range[:start_ip_d1] == range[:end_ip_d1]
  end
end
