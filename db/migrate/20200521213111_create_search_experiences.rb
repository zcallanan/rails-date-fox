class CreateSearchExperiences < ActiveRecord::Migration[6.0]
  def change
    create_table :search_experiences do |t|
      t.references :search, foreign_key: true
      t.references :experience, foreign_key: true

      t.timestamps
    end
  end
end
