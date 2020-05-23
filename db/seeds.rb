# starts_at & ends_at are datetime type

require "csv"

SearchActivity.destroy_all

SearchExperience.destroy_all
ItemOperatingHour.destroy_all
ItemExperience.destroy_all
OperatingHour.destroy_all
Photo.destroy_all
Item.destroy_all
ItemCategory.destroy_all
Activity.destroy_all
Experience.destroy_all
# edit


activities = [
  ['Dinner & Lunch', 120],
  ['Bar', 90],
  ['Club & Dance', 90],
  ['Breakfast', 75],
  ['Events, Shows & Movies', 150],
  ['Theatres & Operas', 180],
  ['Concerts & Festivals', 180],
  ['Museums & Sites', 120],
  ['Indoor Activity', 90],
  ['Outdoor Activity', 180]
]

csv_read_options = { col_sep: ',', quote_char: '"', headers: :first_row }
category_list = []
CSV.foreach('categories.csv', csv_read_options) do |csv_row|
  category_list << csv_row
end

# SEED ACTIVITIES
activities.each do |value|
  activity = Activity.create!(
    name: value[0],
    duration: value[1]
  )
  category_list.each do |row|
    next if row[1] != activity.name

    item_category = ItemCategory.create!(
      name: row[0],
      activity_reference: row[1],
      alias: row[2]
    )

    puts item_category.name
    items = YelpApiService.new(
      location: 'Munich',
      radius: 10_000,
      category: item_category.name,
      price_range: 2
    ).call
    items.each do |item|
      item.update!(activity: activity, item_category: item_category)
    end
  end
end

puts 'Finished!'
