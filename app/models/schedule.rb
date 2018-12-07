class Schedule < ApplicationRecord
  belongs_to :owner, class_name: 'User', foreign_key: :owner_id

  has_many :appontments, foreign_key: :schedule_id, dependent: :destroy

  validates :week_day, presence: true, inclusion: { in: 1..7 }
  validates :hour, presence: true, inclusion: { in: 0..23 }
end
