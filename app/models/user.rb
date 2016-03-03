class User < ActiveRecord::Base

  # опции authlogic
  acts_as_authentic do |c|
    c.crypto_provider = Authlogic::CryptoProviders::Sha512 # алгоритм хэширования пароля
  end

  before_save :set_activity

  belongs_to :organization

  validates :name, length: {minimum: 3, maximum: 255}

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
