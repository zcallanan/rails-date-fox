class CreateItemKinds < ActiveRecord::Migration[6.0]
  def change
    create_table :item_kinds do |t|
      t.string :name
      t.references :item, null: false, foreign_key: true

      t.timestamps
    end
  end
end
