class RemoveColumnsFromItems < ActiveRecord::Migration[6.0]
  def change
    remove_column :items, :open_time
    remove_column :items, :close_time
    remove_column :items, :price
    remove_column :items, :days_closed
  end
end
