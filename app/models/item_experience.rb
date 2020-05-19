class ItemExperience < ApplicationRecord
  belongs_to :experience
  belongs_to :item
end
