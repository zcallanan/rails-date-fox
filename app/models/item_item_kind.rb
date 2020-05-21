class ItemItemKind < ApplicationRecord
  belongs_to :item_kinds
  belongs_to :items
end
