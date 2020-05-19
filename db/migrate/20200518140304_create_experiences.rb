class CreateExperiences < ActiveRecord::Migration[6.0]
  def change
    create_table :experiences do |t|
      t.datetime :starts_at
      t.datetime :ends_at
      t.string :name

      t.timestamps
    end
  end
end
