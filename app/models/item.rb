class Item < ApplicationRecord
  belongs_to :activity, optional: true
  belongs_to :item_category, optional: true
  has_many :item_experiences
  has_many :experiences, through: :item_experiences
  has_many :item_operating_hours
  has_many :operating_hours, through: :item_operating_hours
  has_many :photos
  has_many :join_item_attrs
  has_many :item_attributes, through: :join_item_attrs
end
