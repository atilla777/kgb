class Service < ActiveRecord::Base
  include Datatableable

  PROTOCOLS = ['tcp', 'udp']

  LEGALITIES = {1 => I18n.t('messages.message_yes'), 0 => I18n.t('messages.message_no')}

  belongs_to :organization

  validates :name, length: {minimum: 3, maximum: 255}
  validates :name, uniqueness: {scope: [:port, :host, :protocol]}, allow_blank: true

  validates :port, uniqueness: {scope: [:host, :protocol]}
  validates :port, numericality: {only_integer: true}, allow_blank: true
  validates :port, inclusion: {in: 0..65535}, allow_blank: true

  validates :host, uniqueness: {scope: [:port, :protocol]}
  validates :host, length: {minimum: 7, maximum: 30}

  validates :protocol, uniqueness: {scope: [:port, :host]}, allow_blank: true
  validates :protocol, inclusion: {in: PROTOCOLS}, allow_blank: true

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
  
  # make array of ip addresses from array of ip adddresses and ip ranges
  # ['192.168.1.1', '192.168.1.2-192.168.1.3'] -> ['192.168.1.1', '192.168.1.2', '192.168.1.3']
  def self.normilize_hosts(hosts)
    normilized_hosts = []
    ip4_regexp = /(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])/
    hosts.each do |host|
      if /^(#{ip4_regexp})-(#{ip4_regexp})$/ =~ host
        range = /^(?<start_ip>#{ip4_regexp})-(?<end_ip>#{ip4_regexp})$/.match(host)
        normilized_hosts += (IPAddr.new(range[:start_ip])..IPAddr.new(range[:end_ip])).map(&:to_s).to_a
      elsif /^(#{ip4_regexp})$/ =~ host
        normilized_hosts << host
      end
    end
    normilized_hosts.uniq
  end
end
