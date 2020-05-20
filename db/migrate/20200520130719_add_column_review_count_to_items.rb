class AddColumnReviewCountToItems < ActiveRecord::Migration[6.0]
  def change
    add_column :items, :review_count, :integer
  end
end
