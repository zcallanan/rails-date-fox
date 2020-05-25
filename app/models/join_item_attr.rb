class JoinItemAttr < ApplicationRecord
  belongs_to :item
  belongs_to :item_attribute
end
