class Job < ActiveRecord::Base

  belongs_to :organization
  has_many :schedules, dependent: :destroy
  #has_many :scanned_ports, dependent: :destroy
  belongs_to :option_set

  validates :name, length: {minimum: 3, maximum: 255}
  validates :name, uniqueness: {scope: :organization_id}
  validates :options, length: {minimum: 3, maximum: 255}, allow_blank: true
  validates :ports, presence: true
  validates :hosts, presence: true
  validates :organization_id, numericality: {only_integer: true}
  validates :option_set_id, numericality: {only_integer: true}


  scope :today_jobs, ->{joins(:schedules).merge(Schedule.where("week_day = :week_day OR month_day = :month_day",
                                                               {week_day: Time.now.wday, month_day: Time.now.day}))}

end
