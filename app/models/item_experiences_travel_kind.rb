class ItemExperiencesTravelKind < ApplicationRecord
  belongs_to :travel_kinds
  belongs_to :item_experiences
end
