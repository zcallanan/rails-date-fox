class CreateItemItemKinds < ActiveRecord::Migration[6.0]
  def change
    create_table :item_item_kinds do |t|
      t.references :item_kind, null: false, foreign_key: true
      t.references :item, null: false, foreign_key: true

      t.timestamps
    end
  end
end
