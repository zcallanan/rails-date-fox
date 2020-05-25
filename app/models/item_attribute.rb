class ItemAttribute < ApplicationRecord
  has_many :join_item_attrs
  has_many :items, through: :join_item_attrs
end
