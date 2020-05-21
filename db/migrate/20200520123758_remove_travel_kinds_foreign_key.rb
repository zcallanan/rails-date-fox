class RemoveTravelKindsForeignKey < ActiveRecord::Migration[6.0]
  def change
    remove_reference :travel_kinds, :item_experience, index: true, foreign_key: true
  end
end
