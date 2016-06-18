class OptionSet < ActiveRecord::Base
  NMAP_OPTIONS = {syn_scan: 'sS',
                  skip_discovery: 'PN',
                  udp_scan: 'sU',
                  service_scan: 'sV',
                  os_fingerprint: 'O',
                  top_ports: '--top-ports'}.freeze

  attr_accessor :syn_scan,
                :skip_discovery,
                :udp_scan,
                :os_fingerprint,
                :service_scan,
                :top_ports

  before_save :set_options

  serialize :options, Hash

  has_many :jobs, dependent: :destroy

  validates :name, length: {minimum: 3, maximum: 255}
  validates :top_ports, inclusion: {in: 1..1000}, allow_blank: true

  def show_options
    result = options.select do |key, value|
      if key == :top_ports
        value
      else
        value != '0'
      end
    end
    result = result.map do |key, value|
      if key == :top_ports && value.present?
        "--top-ports #{value}"
      else
        "-#{NMAP_OPTIONS[key]} (#{key})"
      end
    end
    result = result.join(', ')
    result
  end

  def syn_scan
    options[:syn_scan]
  end

  def syn_scan=(value)
    options[:syn_scan] = value
  end

  def skip_discovery
    options[:skip_discovery]
  end

  def skip_discovery=(value)
    options[:skip_discovery] = value
  end

  def udp_scan
    options[:udp_scan]
  end

  def udp_scan=(value)
    options[:udp_scan] = value
  end

  def os_fingerprint
    options[:os_fingerprint]
  end

  def os_fingerprint=(value)
    options[:os_fingerprint] = value
  end

  def service_scan
    options[:service_scan]
  end

  def service_scan=(value)
    options[:service_scan] = value
  end

  def top_ports
    options[:top_ports]
  end

  def top_ports=(value)
    options[:top_ports] = value.to_i if value.present?
  end

  private

  def set_options
    self.options = {syn_scan: syn_scan,
                    skip_discovery: skip_discovery,
                    udp_scan: udp_scan,
                    service_scan: service_scan,
                    os_fingerprint: os_fingerprint,
                    top_ports: top_ports
      }
  end
end
