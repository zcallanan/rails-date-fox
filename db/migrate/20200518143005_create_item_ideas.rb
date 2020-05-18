class CreateItemIdeas < ActiveRecord::Migration[6.0]
  def change
    create_table :item_ideas do |t|
      t.integer :travel_time
      t.references :idea, null: false, foreign_key: true
      t.references :item, null: false, foreign_key: true

      t.timestamps
    end
  end
end
