class Activity < ApplicationRecord
  has_many :search_activities
  has_many :items, dependent: :delete_all
end
