class User < ActiveRecord::Base
  rolify

  ROLES = {admin: I18n.t('roles.admin'),
           editor: I18n.t('roles.editor'),
           viewer: I18n.t('roles.viewer'),
           organization_viewer: I18n.t('roles.organization_viewer'),
           organization_editor: I18n.t('roles.organization_editor')}.freeze

  # опции authlogic
  acts_as_authentic do |c|
    c.crypto_provider = Authlogic::CryptoProviders::Sha512 # алгоритм хэширования пароля
    c.merge_validates_format_of_email_field_options message: 'должно быть адресом электронной почты'
    c.merge_validates_uniqueness_of_email_field_options if: :active
    # не проверять пароль и электронную почту для пользователя которому не разрешен вход (поле active для которого не установлено) или если пароль не вводится
    condition = proc do
      (password.present? || password_confirmation.present?) ||
        (new_record? && active) ||
        (crypted_password.blank? && active)
    end
    c.merge_validates_length_of_password_field_options minimum: 6, if: condition
    c.merge_validates_confirmation_of_password_field_options if: condition
    c.merge_validates_length_of_password_confirmation_field_options if: condition
    c.merge_validates_format_of_email_field_options if: condition
  end

  before_save :set_activity

  belongs_to :organization

  validates :name, length: {minimum: 3, maximum: 255}
  validates :phone, length: {maximum: 40}
  validates :job, length: {maximum: 255}
  validates :department, length: {maximum: 255}
  validates :organization_id, numericality: {only_integer: true}
  validates :email, uniqueness: {allow_blank: true}

  def self.roles
    ROLES
  end

  def show_active
    active ? I18n.t('messages.message_yes') : I18n.t('messages.message_no')
  end

  # services allowed for user role
  def services
    ServicePolicy::Scope.new(self, Service).resolve
  end

  # allowed for user role hosts registered as services
  def services_hosts
    services.group(:host).pluck(:host)
  end

  # allowed fo user role jobs
  def jobs
    JobPolicy::Scope.new(self, Job).resolve
  end

  # active ports scan results scoped by jobs allowed for user role and registered as service hosts
  def jobs_active_services
    ScannedPort.where(host: services_hosts)
               .where(job_id: jobs.pluck(:id))
               .where(state: 'open')
               .joins(%q(
                       INNER JOIN (SELECT scanned_ports.job_id,
                       MAX(scanned_ports.job_time)
                       AS 'max_time' FROM scanned_ports
                       GROUP BY scanned_ports.job_id)a
                       ON a.job_id = scanned_ports.job_id
                       AND a.max_time = scanned_ports.job_time
                      )
                     )
               .group(:port, :protocol, :host).includes(:job).includes(:organization)
  end

  # доступные для роли пользователя (через доступные пользователю работы),
  # имеющиеся в последних результатах сканирования хосты (с открытыми портами) и связанные с ними (через сервисы)
  # организации (если таковые есть)
  def hosts
    ScannedPort.select("servers.name AS 'host_name', servers.id AS 'server_id', scanned_ports.host, organizations.id AS 'organization_id', organizations.name AS 'organization_name'")
             .where(job_id: jobs.pluck(:id))
             .where(state: 'open')
             .joins(%q(
                     INNER JOIN (SELECT scanned_ports.job_id,
                     MAX(scanned_ports.job_time)
                     AS 'max_time' FROM scanned_ports
                     GROUP BY scanned_ports.job_id)a
                     ON a.job_id = scanned_ports.job_id
                     AND a.max_time = scanned_ports.job_time
                    )
                   )
             .joins("LEFT JOIN services ON services.host = scanned_ports.host")
             .joins("LEFT JOIN services AS servers ON (servers.host = scanned_ports.host AND servers.port IS NULL)")
             .joins("LEFT JOIN organizations ON services.organization_id = organizations.id")
             .group(:host, :organization)#.includes(:organization)
             #.joins("LEFT JOIN services ON services.host = scanned_ports.host")
             #.joins("LEFT JOIN organizations ON services.organization_id = organizations.id")
  end

  private

  def set_organizations
    @organizations = Organization.all
  end

  # установка полей разрешающих пользователю вход в систему
  # (authlogic разрешит вход пользователю только если поля active, approved и confirmed имеют значения true)
  def set_activity
    return unless active # если при создании пользователя установлен checkbox
    self.confirmed = true
    self.approved = true
  end
end
