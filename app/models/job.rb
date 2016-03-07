class Job < ActiveRecord::Base

  belongs_to :organization
  has_many :schedules

  validates :name, length: {minimum: 3, maximum: 255}
  validates :name, uniqueness: true # !!! добавить провеорку уникальности имени в сочетании с организацией
  validates :options, presence: true
  validates :ports, presence: true
  validates :hosts, presence: true
  validates :organization_id, numericality: {only_integer: true}


  scope :today_jobs, ->{joins(:schedules).merge(Schedule.where("week_day = :week_day OR month_day = :month_day",
                                                               {week_day: Time.now.wday, month_day: Time.now.day}))}

end
