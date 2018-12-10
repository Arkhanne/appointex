class Appointment < ApplicationRecord
  belongs_to :owner, class_name: 'User', foreign_key: :owner_id
  belongs_to :caller, class_name: 'User', foreign_key: :caller_id
end
