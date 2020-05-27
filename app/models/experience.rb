class Experience < ApplicationRecord
  has_many :item_experiences
  has_many :items, through: :item_experiences, dependent: :destroy
  has_many :search_experiences
  has_many :searches, through: :search_experiences
  has_many :bookings
  has_many :users, through: :bookings
end
