class CreateJoinItemAttrs < ActiveRecord::Migration[6.0]
  def change
    create_table :join_item_attrs do |t|
      t.references :item, null: false, foreign_key: true
      t.references :item_attribute, null: false, foreign_key: true

      t.timestamps
    end
  end
end
