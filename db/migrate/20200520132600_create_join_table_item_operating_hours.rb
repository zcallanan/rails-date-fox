class CreateJoinTableItemOperatingHours < ActiveRecord::Migration[6.0]
  def change
    create_join_table :items, :operating_hours do |t|
      t.references :items, null: false, foreign_key: true
      t.references :operating_hours, null: false, foreign_key: true
    end
  end
end
