class CreateActivityCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :activity_categories do |t|
      t.string :name
      t.references :activity, foreign_key: true

      t.timestamps
    end
  end
end
