class ChangeItemRatingToFloat < ActiveRecord::Migration[6.0]
  def change
    change_column :items, :rating, :float
  end
end
