class AddColumnItemsPriority < ActiveRecord::Migration[6.0]
  def change
    add_column :items, :priority, :integer, default: 4
  end
end
