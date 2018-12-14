class User < ApplicationRecord
  has_many :schedules, foreign_key: :owner_id, dependent: :destroy
  has_many :owner_appointments, class_name: 'Appointment', foreign_key: :owner_id, dependent: :destroy
  has_many :caller_appointments, class_name: 'Appointment', foreign_key: :caller_id, dependent: :destroy

  has_secure_password

  enum gender: [ :male, :female ]
  enum user_type: [ :professional, :client ]

  validates :name, presence: true
  validates :email, presence: true,
                    format: /\A\S+@\S+\z/,
                    uniqueness: { case_sensitive: false }
  validates :gender, inclusion: { in: genders }
  validates :age,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :user_type, presence: true, inclusion: { in: user_types}

  after_create :generate_schedule_cache

  def self.authenticate(email, password)
    user = User.find_by(email: email)
    user && user.authenticate(password)
  end

  def works_for?(week_day:, hour:)
    Schedule.exist?(owner: self, week_day: week_day, hour: hour)
  end

  def schedule_for(week_day:, hour:)
    works_for?(week_day: week_day, hour: hour) ? schedules.find_by(week_day: week_day, hour: hour) : Schedule.new(owner: self, week_day: week_day, hour: hour)
  end

  def has_an_appointment?(owner:, date:)
    if owner.id == self.id
      Appointment.exists?(owner: owner, date: date)
    else
      Appointment.exists?(owner: owner, caller: self, date: date)
    end
  end

  def appointment_for(owner:, date:)
    has_an_appointment?(owner: owner, date: date) ? Appointment.find_by(owner: owner, date: date) : Appointment.new(owner: owner, caller: self, owner: owner, date: date)
  end

  def generate_schedule_cache
    1.upto(7).each do |week_day|
      0.upto(23).each do |hour|
        Rails.cache.write(Schedule.cache_key(owner: self, week_day: week_day%7, hour: hour), false)
      end
    end
  end

end
