class CreateItemExperiences < ActiveRecord::Migration[6.0]
  def change
    create_table :item_experiences do |t|
      t.integer :travel_time
      t.references :experience, null: false, foreign_key: true
      t.references :item, null: false, foreign_key: true

      t.timestamps
    end
  end
end
