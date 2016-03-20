class Service < ActiveRecord::Base

  PROTOCOLS = ['tcp', 'udp']

  belongs_to :organization

  validates :name, length: {minimum: 3, maximum: 255}
  validates :name, uniqueness: {scope: [:port, :host, :protocol]}, allow_blank: true

  validates :port, uniqueness: {scope: [:host, :protocol]}
  validates :port, numericality: {only_integer: true}, allow_blank: true
  validates :port, inclusion: {in: 0..65535}, allow_blank: true

  validates :host, uniqueness: {scope: [:port, :protocol]}
  validates :host, length: {minimum: 7, maximum: 15}

  validates :protocol, uniqueness: {scope: [:port, :host]}, allow_blank: true
  validates :protocol, inclusion: {in: PROTOCOLS}, allow_blank: true

  def self.protocols
    PROTOCOLS
  end

  def show_legality
    if self.legality?
      I18n.t('messages.message_yes')
    else
      I18n.t('messages.message_no')
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

end
