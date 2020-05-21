class Item < ApplicationRecord
  belongs_to :activity, optional: true
  has_many :experiences, through: :item_experiences
  has_many :item_operating_hours
  has_many :operating_hours, through: :item_operating_hours
  has_many :photos
end
