class Search < ApplicationRecord
  belongs_to :user
  has_many :search_activities
  has_many :activities, through: :search_activities 
end
