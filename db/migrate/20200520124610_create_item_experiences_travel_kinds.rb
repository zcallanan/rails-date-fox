class CreateItemExperiencesTravelKinds < ActiveRecord::Migration[6.0]
  def change
    create_table :item_experiences_travel_kinds do |t|
      t.references :travel_kinds, null: false, foreign_key: true
      t.references :item_experiences, null: false, foreign_key: true
    end
  end
end
