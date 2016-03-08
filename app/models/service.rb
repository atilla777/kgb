class Service < ActiveRecord::Base

  PROTOCOLS = { 6 => 'TCP', 17 => 'UDP'}

  belongs_to :organization

  validates :name, length: {minimum: 3, maximum: 255}
  validates :name, uniqueness: {scope: [:port, :host_ip, :protocol]}

  validates :port, uniqueness: {scope: [:host_ip, :protocol]}
  validates :port, numericality: {only_integer: true}
  validates :port, inclusion: {in: 0..65535}

  validates :host_ip, uniqueness: {scope: [:port, :protocol]}
  validates :host_ip, length: {minimum: 7, maximum: 15}

  validates :protocol, uniqueness: {scope: [:port, :host_ip]}
  validates :protocol, inclusion: {in: PROTOCOLS.keys}

  def show_protocol
    PROTOCOLS[self.protocol.to_i]
  end

  def self.protocols
    PROTOCOLS
  end

  def show_legality
    if self.legality?
      'Да'
    else
      'Нет'
    end
  end

  def self.show_protocol_number(protocol_name)
    PROTOCOLS.key(protocol_name.to_s.upcase)
  end

  def self.legality_key(state, host_ip, port, protocol)
    service = Service.where(host_ip: host_ip, port: port, protocol: Service.show_protocol_number(protocol)).first
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

end
