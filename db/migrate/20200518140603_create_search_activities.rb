class CreateSearchActivities < ActiveRecord::Migration[6.0]
  def change
    create_table :search_activities do |t|
      t.references :search, null: false, foreign_key: true
      t.references :activity, null: false, foreign_key: true

      t.timestamps
    end
  end
end
