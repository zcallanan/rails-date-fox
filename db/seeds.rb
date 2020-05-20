# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# starts_at & ends_at are datetime type

require 'json'
require 'open-uri'

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

# SEED ACTIVITIES
activities.each do |value|
  activity = Activity.new(
    name: value[0],
    duration: value[1]
  )
  activity.save
end

categories = File.open('item_kinds.txt').read.split("\n")

API_KEY = ENV.fetch('YELP_API')

categories.each do |category|
  url = "https://api.yelp.com/v3/businesses/search?location=Munich&radius=10000&categories=#{category}"
  serialized_data = open(url, 'Authorization' => "Bearer #{API_KEY}").read
  data = JSON.parse(serialized_data)
  data.each_with_index do |value, index|
    row = value['businesses'][index]
    location = row['location']
    item = Item.new(
      name: row.name,
      # description: "A cool place to eat",
      address: "#{location[address1]} #{location[address2]} #{location[address3]}, #{location[city]} #{location[zip_code]}",
      availability: true,
      rating: row.rating,
      price_range: row.price.size,
      review_count: row.review_count
    )
    url = "https://api.yelp.com/v3/businesses/#{row.id}"
    url = "https://api.yelp.com/v3/businesses/HI7M_qC-q2P7U8a7kIfW6g"


    ser_data = open(url, 'Authorization' => "Bearer #{API_KEY}").read
    item_data = JSON.parse(ser_data)

    item_data.each do |x|
      hours = val['hours'][0]['open']
    end
    item_data.each_with_index do |val, ind|
      hours
      day_values = (0..6).to_a
      hours.each do |day|
        if index == hours.length - 1
          item.open_time += day['start']
          item.close_time += day['end']
        else
          item.open_time += "#{day['start']},"
          item.close_time += "#{day['end']},"
        end
        day_values.each_with_index do |num, i|
          day_values[i] = 0 if num == day['day']
        end
      end
      day_values.each_with_index do |num, dex|
        if num.positive?
          dex == day_values.length - 1 ? item.days_closed += num : item.days_closed += "#{num},"
        end
      end
      photos = val['photos']
      photos.each do |photo|
        image_url = photo.to_s
        file = URI.open(image_url)
        item.photo.attach(
          io: file,
          filename: "#{row.name}_#{ind}",
          content_type: 'image/jpg'
        )
      end

    end


  end






end

# 5.times do
#   experience = Experience.new(
#     starts_at: "15-06-20 18:00",
#     ends_at: "15-06-20 21:00",
#     name: "Romantic"
#   )
#   experience.save



#   item = Item.new(
#     name: "Chez",
#     description: "A cool place to eat",
#     address: "1 Awesome Way, Munich 80634",
#     availability: true,
#     open_time: "12:00",
#     close_time: "23:30",
#     rating: 8.3,
#     price: 0,
#     price_range: 3,
#     days_closed: 6
#   )

#   # assign an activity foreign key value to item
#   item.activity = activity
#   item.save

#   item_experience = ItemExperience.new(
#     travel_time: 30
#   )

#   # assign an item foreign key value to item_experience
#   item_experience.item = item

#   # assign an experience foreign key value to item_experience
#   item_experience.experience = experience
#   item_experience.save
# end

# puts "finished!"
