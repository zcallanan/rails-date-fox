class CreateOperatingHours < ActiveRecord::Migration[6.0]
  def change
    create_table :operating_hours do |t|
      t.integer :day
      t.boolean :open_today
      t.time :open_time
      t.time :close_time

      t.timestamps
    end
  end
end
