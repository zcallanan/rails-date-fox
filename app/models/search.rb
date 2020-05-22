class Search < ApplicationRecord
  belongs_to :user
  has_many :search_activities
  has_many :activities, through: :search_activities
  has_many :search_experiences
  has_many :experiences, through: :search_experiences
end
