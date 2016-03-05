class User < ActiveRecord::Base

  # опции authlogic
  acts_as_authentic do |c|
    c.crypto_provider = Authlogic::CryptoProviders::Sha512 # алгоритм хэширования пароля
    c.merge_validates_format_of_email_field_options message: 'должно быть адресом электронной почты'
    c.merge_validates_length_of_password_field_options({:minimum => 6}) # минимальная длина пароля
    # не проверять пароль и электронную почту для пользователя которому не разрешен вход (поле active для которого не установлено)
    c.merge_validates_confirmation_of_password_field_options if: :active
    c.merge_validates_length_of_password_confirmation_field_options if: :active
    # !!! сделать проверку уникальности этого поля (password), если это поле не пустое
    c.merge_validates_length_of_password_field_options if: :active
    c.merge_validates_format_of_email_field_options if: :active
    # !!! сделать проверку уникальности этого поля (email), если это поле не пустое
    c.merge_validates_uniqueness_of_email_field_options if: :active
  end

  before_save :set_activity

  belongs_to :organization

  validates :name, length: {minimum: 3, maximum: 255}
  validates :phone, length: {maximum: 25}

  private

  # установка полей разрешающих пользователю вход в систему
  # (authlogic разрешит вход пользователю только если поля active, approved и confirmed имеют значения true)
  def set_activity
    if self.active # если при создании пользователя установлен checkbox
      self.confirmed = true
      self.approved = true
    end
  end

end
