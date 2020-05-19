# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# starts_at & ends_at are datetime type
experience = Experience.new(
  starts_at: "15-06-20 18:00",
  ends_at: "15-06-20 21:00",
  name: "Romantic"
)
experience.save

activity = Activity.new(
  name: "Romantic",
  duration: 120
)
activity.save

item = Item.new(
  name: "Chez",
  description: "A cool place to eat",
  address: "1 Awesome Way, Munich 80634",
  availability: true,
  open_time: "12:00",
  close_time: "23:30",
  rating: 8.3,
  price: 0,
  price_range: 3,
  days_closed: 6
)

# assign an activity foreign key value to item
item.activity = activity
item.save

item_experience = ItemExperience.new(
  travel_time: 30
)

# assign an item foreign key value to item_experience
item_experience.item = item

# assign an experience foreign key value to item_experience
item_experience.experience = experience
item_experience.save

puts "finished!"
