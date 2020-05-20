class CreateJoinTableItemItemKinds < ActiveRecord::Migration[6.0]
  def change
    create_join_table :item_kinds, :items do |t|
      t.references :item_kinds, null: false, foreign_key: true
      t.references :items, null: false, foreign_key: true
    end
  end
end
