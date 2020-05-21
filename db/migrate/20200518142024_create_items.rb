class CreateItems < ActiveRecord::Migration[6.0]
  def change
    create_table :items do |t|
      t.string :name
      t.string :description
      t.string :address
      t.boolean :availability, default: true, null: false
      t.time :open_time
      t.time :close_time
      t.integer :rating
      t.integer :price_range
      t.integer :price
      t.string :days_closed
      t.references :activity, foreign_key: true

      t.timestamps
    end
  end
end
