class Service < ActiveRecord::Base
  include Datatableable

  IP4_REGEXP = /(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])/
  IP4_D1_3_REGEXP = /(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}/
  IP4_D4_REGEXP = /([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])/

  PROTOCOLS = ['tcp', 'udp']

  LEGALITIES = {1 => I18n.t('messages.message_yes'), 0 => I18n.t('messages.message_no')}

  belongs_to :organization

  validates :name, length: {minimum: 3, maximum: 255}
  validates :name, uniqueness: {scope: [:port, :host, :protocol]}, allow_blank: true

  validates :port, uniqueness: {scope: [:host, :protocol]}
  validates :port, numericality: {only_integer: true}, allow_blank: true
  validates :port, inclusion: {in: 0..65535}, allow_blank: true

  validate :host_is_ip4_or_range
  validates :host, uniqueness: {scope: [:port, :protocol]}

  validates :protocol, uniqueness: {scope: [:port, :host]}, allow_blank: true
  validates :protocol, inclusion: {in: PROTOCOLS}, allow_blank: true

  def self.ip4_regexp
    IP4_REGEXP
  end

  def self.ip4_d4_regexp
    IP4_D4_REGEXP
  end

  def self.ip4_d1_3_regexp
    IP4_D1_3_REGEXP
  end

  def self.legalities
    LEGALITIES
  end

  def self.protocols
    PROTOCOLS
  end

  def self.show_legality(legality)
    if legality == 1
      I18n.t('messages.message_yes')
    elsif legality == 0
      I18n.t('messages.message_no')
    else
      I18n.t('messages.unknown')
    end
  end

  def show_legality
    if self.legality?
      I18n.t('messages.message_yes')
    else
      I18n.t('messages.message_no')
    end
  end

  def show_host
    if port.present?
      ''
    else
        I18n.t('activerecord.attributes.scanned_port.host')
    end
  end

  def self.legality_key(state, host, port, protocol)
    service = Service.where(host: host, port: port, protocol: protocol).first
    if state == :closed
      legality = 3 # no means
    else
      if service.present?
        if service.legality == 1
          legality = 1 # true
        else
          legality = 0 #false
        end
      else
        legality = 2 # unknown
      end
    end
    legality
  end

  # Make array of ip addresses from array of ip adddresses and ip ranges
  # Example:
  #   Service.normilized_hosts(['192.168.1.1', '192.168.1.2-192.168.1.3', '172.16.1-2']) ->
  #   ['192.168.1.1', '192.168.1.2', '192.168.1.3', '172.16.1.1', '172.16.1.2']
  def self.normilize_hosts(hosts)
    normilized_hosts = []
    hosts.each do |host|
      if /\A(#{ip4_regexp})-(#{ip4_regexp})\z/ =~ host
        range = /\A(?<start_ip>#{ip4_regexp})-(?<end_ip>#{ip4_regexp})\z/.match(host)
        normilized_hosts += (IPAddr.new(range[:start_ip])..IPAddr.new(range[:end_ip])).map(&:to_s).to_a
      elsif /\A(#{ip4_regexp})\z/ =~ host
        normilized_hosts << host
      elsif /\A(#{Service.ip4_d1_3_regexp})(#{Service.ip4_d4_regexp})-(#{Service.ip4_d4_regexp})\z/ =~ host
        range2 = /\A(?<start_ip_d1_3>#{Service.ip4_d1_3_regexp})(?<start_ip_d4>#{Service.ip4_d4_regexp})-(?<end_ip_d4>#{Service.ip4_d4_regexp})\z/.match(host)
        normilized_hosts += (IPAddr.new(range2[:start_ip_d1_3] << range2[:start_ip_d4])..IPAddr.new(range2[:start_ip_d1_3] << range2[:end_ip_d4])).map(&:to_s).to_a
      end
    end
    normilized_hosts.uniq
  end

  private

  def host_is_ip4_or_range
    range = /\A(?<start_ip>#{Service.ip4_regexp})-(?<end_ip>#{Service.ip4_regexp})\z/.match(host)
    range2 = /\A(?<start_ip_d1_3>#{Service.ip4_d1_3_regexp})(?<start_ip_d4>#{Service.ip4_d4_regexp})-(?<end_ip_d4>#{Service.ip4_d4_regexp})\z/.match(host)
    unless /\A#{Service.ip4_regexp}\z/ =~ host || range || range2
      errors[:host] << I18n.t('errors.messages.must_be_ip4_or_range')
    end
    # check the second ip in range is greater then the first ip
    if range
      if IPAddr.new(range[:start_ip]).to_i > IPAddr.new(range[:end_ip]).to_i
        errors[:host] << I18n.t('errors.messages.must_be_ip4_or_range')
      end
    elsif range2
      if range2[:start_ip_d4].to_i > range2[:end_ip_d4].to_i
        errors[:host] << I18n.t('errors.messages.must_be_ip4_or_range')
      end
    end
  end
end
