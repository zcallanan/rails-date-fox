class ItemExperiencesTravelKind < ApplicationRecord
  belongs_to :travel_kind
  belongs_to :item_experience
end
