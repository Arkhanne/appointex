class Schedule < ApplicationRecord
  belongs_to :owner, class_name: 'User', foreign_key: :owner_id

  validates :week_day, presence: true, inclusion: { in: 0..6 }
  validates :hour, presence: true, inclusion: { in: 0..23 }

  after_create :write_cache
  after_destroy :purge_cache

  def self.cache_key(owner:, week_day:, hour:)
    owner.id.to_s + '_' + week_day.to_s + '_' + hour.to_s
  end

  def self.exist?(owner:, week_day:, hour:)
    Rails.cache.fetch(cache_key(owner: owner, week_day: week_day, hour: hour)) do
      Schedule.exists?(owner: owner, week_day: week_day, hour: hour)
    end
  end

  private

  def write_cache
    Rails.cache.write(Schedule.cache_key(owner: owner, week_day: week_day, hour: hour), true)
  end

  def purge_cache
    Rails.cache.write(Schedule.cache_key(owner: owner, week_day: week_day, hour: hour), false)
  end
end
