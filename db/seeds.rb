# starts_at & ends_at are datetime type

require "csv"

JoinItemAttr.destroy_all
SearchActivity.destroy_all
SearchExperience.destroy_all
ItemOperatingHour.destroy_all
ItemExperience.destroy_all
OperatingHour.destroy_all
Photo.destroy_all
ItemAttribute.destroy_all
Item.destroy_all
ItemCategory.destroy_all
Activity.destroy_all
Experience.destroy_all
Search.destroy_all

bar_images = [
  'https://images.unsplash.com/photo-1514933651103-005eec06c04b',
  'https://images.unsplash.com/photo-1491333078588-55b6733c7de6',
  'https://images.unsplash.com/photo-1529502669403-c073b74fcefb',
  'https://images.unsplash.com/photo-1436018626274-89acd1d6ec9d',
  'https://images.unsplash.com/photo-1534157458714-42b1e9cd5727',
]

restaurant_images = [
  'https://images.unsplash.com/photo-1555396273-367ea4eb4db5',
  'https://images.unsplash.com/photo-1525610553991-2bede1a236e2',
  'https://images.unsplash.com/photo-1544739313-6fad02872377',
  'https://images.unsplash.com/photo-1589769105893-3cfe4c0c8851',
  'https://images.unsplash.com/photo-1587574293340-e0011c4e8ecf',
  'https://images.unsplash.com/photo-1563507466372-c61871fff681'
]

museum_images = [
  'https://images.unsplash.com/photo-1586884542514-f6bef0283446?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2767&q=80',
  'https://images.unsplash.com/photo-1584652868574-0669f4292976',
  'https://images.unsplash.com/photo-1566099191530-598e878ebd8b',
  'https://images.unsplash.com/photo-1580539924857-755cdc6aa3c2',
  'https://images.unsplash.com/photo-1566127444941-8e124ffbc59e'
]

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

attribute_list = []
CSV.foreach('attributes.csv', csv_read_options) do |csv_row|
  attribute_list << csv_row
end

# SEED ACTIVITIES
activities.each do |value|
  activity = Activity.create!(
    name: value[0],
    duration: value[1]
  )

  attribute_list.each do |attribute|
    attributes = []
    next if attribute[0] != activity.name

    attributes << [
      attribute[1],
      attribute[2],
      attribute[3],
      attribute[4],
      attribute[5],
      attribute[6],
      attribute[7],
      attribute[8],
      attribute[9],
      attribute[10]
    ].sample(4)
    attributes.flatten!

    item_attributes = []
    attributes.each do |attrs|
      item_attributes << ItemAttribute.create!(
        activity_reference: attribute[0],
        name: attrs
      )
    end

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

        if item.activity.name == 'Dinner & Lunch'
          item.update!(image_url: restaurant_images.sample)
        elsif item.activity.name == 'Bar'
          item.update!(image_url: bar_images.sample)
        elsif item.activity.name == 'Museums & Sites'
          item.update!(image_url: museum_images.sample)
        end

        next if item.item_attributes.size > 4

        item_attributes.each do |att|
          item.item_attributes << att
        end
      end
    end
  end
end

puts 'Finished!'
