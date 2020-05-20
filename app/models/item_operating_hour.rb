class ItemOperatingHour < ApplicationRecord
  belongs_to :items
  belongs_to :operating_hours
end
