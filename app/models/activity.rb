class Activity < ApplicationRecord
  has_many :items, dependent: :delete_all
end
