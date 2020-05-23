class ActivityCategory < ApplicationRecord
  belongs_to :activity, optional: true
  has_many :items, through: :activity
end
