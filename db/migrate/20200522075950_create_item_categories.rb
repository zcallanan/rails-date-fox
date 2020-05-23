class CreateItemCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :item_categories do |t|
      t.string :name
      t.string :alias
      t.string :activity_reference

      t.timestamps
    end
  end
end
