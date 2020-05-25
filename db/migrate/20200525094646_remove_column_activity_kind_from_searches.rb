class RemoveColumnActivityKindFromSearches < ActiveRecord::Migration[6.0]
  def change
    remove_column :searches, :activity_kind
  end
end
