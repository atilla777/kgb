class Schedule < ActiveRecord::Base

  validates :job_id, numericality: {only_integer: true}
  #validates :week_day, numericality: {only_integer: true, allow_blank: true}
  validates :week_day, inclusion: {in: 0..6, allow_blank: true}
  validates :week_day, uniqueness: {scope: [:job_id, :month_day]}
  #validates :month_day, numericality: {only_integer: true, allow_blank: true}
  validates :month_day, inclusion: {in: 1..31, allow_blank: true}
  validates :month_day, uniqueness: {scope: [:job_id, :week_day]}

  belongs_to :job

=begin
  def show_week_day
    if self.week_day.present?
      t('date.days_names')[self.week_day]
    else
      ''
    end
  end

  def self.week_days
    t('date.days_names')
  end

  def self.month_days
    1..31
  end
=end

end
