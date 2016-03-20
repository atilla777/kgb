class ScannedPort < ActiveRecord::Base

  include Datatableable

  LEGALITIES = {0 => I18n.t('types.h_illegal'), 1 => I18n.t('types.h_legal'), 2 => I18n.t('types.h_unknown'), 3 => I18n.t('types.not_needed')}
  STATES = {'open' => I18n.t('types.open'),
            'closed' => I18n.t('types.closed'),
            'open|filtered' => I18n.t('types.open_filtered'),
            'filtered' => I18n.t('types.filtered')}

  belongs_to :organization
  belongs_to :job

  validates :job_id, numericality: {only_integer: true}
  validates :organization_id, numericality: {only_integer: true}
  validates :legality, inclusion: {in: LEGALITIES.keys}

  def show_history_legality
    LEGALITIES[self.legality]
  end

  def show_state
    STATES[self.state]
  end

  def self.states
    STATES
  end

  def self.legalities
    LEGALITIES
  end

end
