class CreateTravelKinds < ActiveRecord::Migration[6.0]
  def change
    create_table :travel_kinds do |t|
      t.string :name
      t.references :item_idea, null: false, foreign_key: true

      t.timestamps
    end
  end
end
