class RemoveReferenceFromItemKinds < ActiveRecord::Migration[6.0]
  def change
    remove_reference :item_kinds, :item, index: true, foreign_key: true
  end
end
