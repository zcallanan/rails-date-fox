class AddExperienceFocusColumnToSearch < ActiveRecord::Migration[6.0]
  def change
    add_column :searches, :experience_focus, :integer
  end
end
