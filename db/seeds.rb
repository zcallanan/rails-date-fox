# starts_at & ends_at are datetime type

require "csv"

ActivityCategory.destroy_all
SearchExperience.destroy_all
SearchActivity.destroy_all
ItemOperatingHour.destroy_all
ItemExperience.destroy_all
OperatingHour.destroy_all
Photo.destroy_all
Item.destroy_all
Activity.destroy_all
Experience.destroy_all



activities = [
  ["Dinner & Lunch", 120],
  ["Bar", 90],
  ["Club & Dance", 90],
  ["Breakfast", 75],
  ["Events, Shows & Movies", 150],
  ["Theatres & Operas", 180],
  ["Concerts & Festivals", 180],
  ["Museums & Sites", 120],
  ["Indoor Activity", 90],
  ["Outdoor Activity", 180]
]

csv_read_options = {col_sep: ',', quote_char: '"', headers: :first_row}
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
    if row[1] == activity.name
      activity.activity_categories << ActivityCategory.create!(name: row[0])
    end
  end

  activity.activity_categories.each do |category|
    puts category.name
    items = YelpApiService.new(
      location: 'Munich',
      radius: 10_000,
      category: category.name,
      price_range: 2
    ).call
    items.each do |item|
      item.update(activity: activity)
    end
  end
end

# csv_read_options = {col_sep: ",", quote_char: '"', headers: :first_row}

# CSV.foreach("categories.csv", csv_read_options) do |csv_row|
#   puts csv_row[0]
#   items = YelpApiService.new(
#     location: "Munich",
#     radius: 10_000,
#     category: csv_row[0]
#   ).call

#   items.each do |item|
#     item.update(activity: Activity.find_by(name: csv_row[1]))
#   end
# end

n = 0
3.times do
  n += 1
  experience = Experience.new(
    name: "Experience #{n}"
  )
  experience.save

  2.times do
    experience.items << Item.all[(0..20).to_a.sample]
  end
end

puts "Finished!"
