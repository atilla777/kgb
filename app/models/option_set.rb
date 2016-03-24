class OptionSet < ActiveRecord::Base

   NMAP_OPTIONS = {syn_scan: "sS",
                  skip_discovery: "PN",
                  udp_scan: "sU",
                  service_scan: "sV",
                  os_fingerprint: "O",
                  top_ports: "--top-ports"}

   attr_accessor :syn_scan, :skip_discovery, :udp_scan, :os_fingerprint, :service_scan, :top_ports

  before_save :set_options


  serialize :options, Hash

  has_many :jobs, dependent: :destroy

  validates :name, length: {minimum: 3, maximum: 255}
  validates :top_ports, inclusion: {in: 1..1000}, allow_blank: true

  def show_options
    result = self.options.select {|key, value| value != '0' }
    result = result.map do |key, value|
      if key == :top_ports and value.present?
        "--top-ports #{value}"
      else
        "-#{NMAP_OPTIONS[key]} (#{key.to_s})"
      end
    end
    result = result.join(', ')
    result
  end

  def syn_scan
    self.options[:syn_scan]
  end
  def syn_scan=(value)
    self.options[:syn_scan] = value
  end

  def skip_discovery
    self.options[:skip_discovery]
  end
  def skip_discovery=(value)
    self.options[:skip_discovery] = value
  end

  def udp_scan
    self.options[:udp_scan]
  end
  def udp_scan=(value)
    self.options[:udp_scan] = value
  end

  def os_fingerprint
    self.options[:os_fingerprint]
  end
  def os_fingerprint=(value)
    self.options[:os_fingerprint] = value
  end

  def service_scan
    self.options[:service_scan]
  end
  def service_scan=(value)
    self.options[:service_scan] = value
  end

  def top_ports
    self.options[:top_ports]
  end
  def top_ports=(value)
    self.options[:top_ports] = value.to_i
  end

  private

  def set_options
    self.options = {syn_scan: self.syn_scan,
        skip_discovery: self.skip_discovery,
        udp_scan: self.udp_scan,
        service_scan: self.service_scan,
        os_fingerprint: self.os_fingerprint,
        top_ports: self.top_ports
      }
  end

end
