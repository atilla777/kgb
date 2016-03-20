class OptionSet < ActiveRecord::Base

  attr_accessor :syn_scan, :skip_discovery, :udp_scan, :os_fingerprint

  before_save :set_options


  serialize :options, Hash

  has_many :jobs, dependent: :destroy

  validates :name, length: {minimum: 3, maximum: 255}



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

  private

  def set_options
    self.options = {syn_scan: self.syn_scan,
        skip_discovery: self.skip_discovery,
        udp_scan: self.udp_scan,
        os_fingerprint: self.os_fingerprint
      }
  end

end
