class ItemOperatingHour < ApplicationRecord
  belongs_to :item
  belongs_to :operating_hour
end
