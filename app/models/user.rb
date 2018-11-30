class User < ApplicationRecord
  has_secure_password

  USER_GENRES = [
    'Male',
    'Female'
  ]

  validates :name, presence: true
  validates :email, presence: true,
                    format: /\A\S+@\S+\z/,
                    uniqueness: { case_sensitive: false }
  validates :genre, inclusion: { in: USER_GENRES }
  validates :age,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
