class CreateItemAttributes < ActiveRecord::Migration[6.0]
  def change
    create_table :item_attributes do |t|
      t.string :activity_reference
      t.string :name

      t.timestamps
    end
  end
end
