class CreateSearches < ActiveRecord::Migration[6.0]
  def change
    create_table :searches do |t|
      t.datetime :starts_at
      t.datetime :ends_at
      t.integer :price_range, default: 0
      t.string :activity_kind
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
