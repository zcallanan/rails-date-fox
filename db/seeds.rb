# starts_at & ends_at are datetime type
Booking.destroy_all

require "csv"

Booking.destroy_all
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
    ]

    attributes.flatten!

    attributes.each do |attrs|
      ItemAttribute.create!(
        activity_reference: attribute[0],
        name: attrs
      )
    end

    all_attributes = ItemAttribute.all
    ten_activity_attributes = []

    all_attributes.each do |a|
      if a.activity_reference == activity.name
        ten_activity_attributes << a
      end
    end

    category_list.each do |row|
      next if row[1] != activity.name

      item_category = ItemCategory.create!(
        name: row[0],
        activity_reference: row[1],
        alias: row[2]
      )

      puts item_category.name
      price = [2, 3]
      price.each do |p|
        items = YelpApiService.new(
          location: 'Munich',
          radius: 10_000,
          category: item_category.name,
          price_range: p
        ).call
        items.each do |item|
          item.update!(activity: activity, item_category: item_category)

          next if item.item_attributes.size > 4

          ten_activity_attributes.sample(4).each do |s|
            item.item_attributes << s
          end
        end
      end
    end
  end
end

puts 'Finished!'
