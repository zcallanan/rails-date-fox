class CreateItemOperatingHours < ActiveRecord::Migration[6.0]
  def change
    create_table :item_operating_hours do |t|
      t.references :items, null: false, foreign_key: true
      t.references :operating_hours, null: false, foreign_key: true

      t.timestamps
    end
  end
end
