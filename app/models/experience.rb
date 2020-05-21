class Experience < ApplicationRecord
  has_many :item_experiences
  has_many :items, through: :item_experiences, dependent: :destroy
end
