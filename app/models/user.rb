class User < ActiveRecord::Base
  rolify

  ROLES = {admin: I18n.t('roles.admin'), editor: I18n.t('roles.editor'), viewer: I18n.t('roles.viewer')
  # опции authlogic
  acts_as_authentic do |c|
    c.crypto_provider = Authlogic::CryptoProviders::Sha512 # алгоритм хэширования пароля
    c.merge_validates_format_of_email_field_options message: 'должно быть адресом электронной почты'
    c.merge_validates_uniqueness_of_email_field_options if: :active
    c.merge_validates_length_of_password_field_options({:minimum => 6}) # минимальная длина пароля
    # не проверять пароль и электронную почту для пользователя которому не разрешен вход (поле active для которого не установлено) или если пароль не вводится
    c.merge_validates_confirmation_of_password_field_options :if => Proc.new {
      (self.password.present? or self.password_confirmation.present?) or (self.new_record? and self.active)}
    c.merge_validates_length_of_password_confirmation_field_options :if => Proc.new {
      (self.password.present? or self.password_confirmation.present?) or (self.new_record? and self.active)}
    c.merge_validates_length_of_password_field_options :if => Proc.new {
      (self.password.present? or self.password_confirmation.present?) or (self.new_record? and self.active)}  c.merge_validates_length_of_password_field_options if: :active
    c.merge_validates_format_of_email_field_options if: :active

  end

  before_save :set_activity

  belongs_to :organization

  validates :name, length: {minimum: 3, maximum: 255}
  validates :phone, length: {maximum: 25}
  validates :job, length: {maximum: 255}
  validates :department, length: {maximum: 255}
  validates :organization_id, numericality: {only_integer: true}
  validates :email, uniqueness: {allow_blank: true}

  def self.roles
    ROLES
  end

  private

  def set_organizations
    @organizations = Organization.all
  end

  # установка полей разрешающих пользователю вход в систему
  # (authlogic разрешит вход пользователю только если поля active, approved и confirmed имеют значения true)
  def set_activity
    if self.active # если при создании пользователя установлен checkbox
      self.confirmed = true
      self.approved = true
    end
  end

end
