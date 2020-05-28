class AddColumnItemsLongDescription < ActiveRecord::Migration[6.0]
  def change
    add_column :items, :long_description, :string
  end
end
