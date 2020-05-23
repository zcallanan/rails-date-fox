class ActivityCategory < ApplicationRecord
  belongs_to :activity, optional: true
  has many :items, through: :activity
end
