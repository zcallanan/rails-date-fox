class CreateItems < ActiveRecord::Migration[6.0]
  def change
    create_table :items do |t|
      t.string :name
      t.string :description
      t.string :address
      t.boolean :availability, default: true, null: false
      t.integer :rating
      t.integer :price_range
      t.integer :review_count
      t.references :activity, foreign_key: true
      t.references :item_category, foreign_key: true

      t.timestamps
    end
  end
end
