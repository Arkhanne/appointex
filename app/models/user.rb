class User < ApplicationRecord
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

  def self.authenticate(email, password)
    user = User.find_by(email: email)
    user && user.authenticate(password)
  end
end
