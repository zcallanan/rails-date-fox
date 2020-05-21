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
require 'csv'
API_KEY = ENV.fetch('YELP_API')

# Activity.destroy_all
# Item.destroy_all
# OperatingHour.destroy_all
# ItemOperatingHour.destroy_all
n = 0
3.times do
  n += 1
  experience = Experience.new(
    name: "Experience #{n}"
  )
  experience.save
end

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
  # SAVE
  activity.save
end

# csv_read_options = { col_sep: ',', quote_char: '"', headers: :first_row }

# CSV.foreach('categories.csv', csv_read_options) do |csv_row|
  # url = "https://api.yelp.com/v3/businesses/search?location=Munich&radius=10000&categories=#{csv_row[0]}"
  url = 'https://api.yelp.com/v3/businesses/search?location=Munich&radius=10000&categories=restaurants'
  serialized_data = open(url, 'Authorization' => "Bearer #{API_KEY}").read
  data = JSON.parse(serialized_data)
  data['businesses'].each do |row|
    location = row['location']
    address_two = " #{location['address2']}" unless location['address2'].nil?
    address_three = " #{location['address3']}" unless location['address3'].nil?
    address_string = "#{location['address1']}#{address_two}#{address_three}, #{location['city']} #{location['zip_code']}"
    row['price'].nil? ? price = 1 : price = row['price'].size
    item = Item.new(
      name: row['name'],
      description: 'A cool place to eat',
      address: address_string,
      availability: true,
      rating: row['rating'],
      price_range: price,
      review_count: row['review_count']
    )
    act = Activity.all
    item.activity = act[0]
    # activities = Activity.all
    # activities.each do |activity|
    #   # item.activity = activity if activity.name == csv_row[1]
    # end

    # SAVE
    item.save
    puts "saved"

    url = "https://api.yelp.com/v3/businesses/#{row['id']}"
    # url = "https://api.yelp.com/v3/businesses/HI7M_qC-q2P7U8a7kIfW6g"

    ser_data = open(url, 'Authorization' => "Bearer #{API_KEY}").read
    item_data = JSON.parse(ser_data)

    # SEED OPERATING HOURS
    hours = item_data['hours'][0]['open']
    hours.each do |val|
      operating_hours = OperatingHour.new(
        day: val['day'],
        open_time: val['start'],
        close_time: val['end']
      )
      # SAVE
      operating_hours.save

      # SEED JOIN TABLE
      item_operating_hours = ItemOperatingHour.new

      item_operating_hours.item = item
      item_operating_hours.operating_hour = operating_hours

      # SAVE
      item_operating_hours.save
    end

    images = item_data['photos']
    images.each_with_index do |photo_url, ind|
      # SEED PHOTOS
      file = URI.open(photo_url)
      item.photos.attach(
        io: file,
        filename: "#{row['name']}_#{ind}",
        content_type: 'image/jpg'
      )
    end
  end
# end

puts 'Finished!'
