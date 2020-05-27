class AddImageUrlColumnToItems < ActiveRecord::Migration[6.0]
  def change
    add_column :items, :image_url, :string
  end
end
