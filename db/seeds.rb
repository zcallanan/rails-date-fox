# starts_at & ends_at are datetime type

require "csv"

ItemOperatingHour.destroy_all
OperatingHour.destroy_all
Photo.destroy_all
Item.destroy_all
Activity.destroy_all
Experience.destroy_all

n = 0
3.times do
  n += 1
  experience = Experience.new(
    name: "Experience #{n}"
  )
  experience.save
end

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

# SEED ACTIVITIES
activities.each do |value|
  Activity.create!(
    name: value[0],
    duration: value[1]
  )
end

csv_read_options = {col_sep: ",", quote_char: '"', headers: :first_row}

CSV.foreach("categories.csv", csv_read_options) do |csv_row|
  puts csv_row[0]
  items = YelpApiService.new(
    location: "Munich",
    radius: 10_000,
    category: csv_row[0]
  ).call

  items.each do |item|
    item.update(activity: Activity.find_by(name: csv_row[1]))
  end
end

puts "Finished!"
