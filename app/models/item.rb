class Item < ApplicationRecord
  belongs_to :activity
  has_many :experiences, through: :item_experiences
  has_many :operating_hours, through: :item_operating_hours

  has_many_attached :photos
end
