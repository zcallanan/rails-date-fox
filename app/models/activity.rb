class Activity < ApplicationRecord
  has_many :search_activities
  has_many :items
  has_many :activity_categories
end
