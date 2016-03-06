class ScannedPort < ActiveRecord::Base

  LEGALITIES = {0 => 'Нет', 1 => 'Да', 2 => 'Неизвестно', 3 => 'Не требуется'}

  belongs_to :organization
  belongs_to :job

  validates :job_id, numericality: {only_integer: true}
  validates :organization_id, numericality: {only_integer: true}
  validates :legality, inclusion: {in: LEGALITIES.keys}

  def show_history_legality
    LEGALITIES[self.legality]
  end

end
