class AddCityToSearches < ActiveRecord::Migration[6.0]
  def change
    add_column :searches, :city, :string
  end
end
