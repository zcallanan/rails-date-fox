class Experience < ApplicationRecord
  has_many :items, through: :item_experiences, dependent: :delete_all
end
