class ExperiencesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]
  before_action :set_experience, only: %i[show]

  def index
    @items = []
    @activity_items = {}

    @activity_array = []
    @experience_items = []
    @item_categories = ItemCategory.all
    @item_attributes = ItemAttribute.all

    # form values
    @search = Search.find(params[:search_id])
    @experiences = @search.experiences
    @city = @search.city
    @price_range = @search.price_range
    @starts_at = @search.starts_at
    @ends_at = @search.ends_at
    @activity_array = @search.activities

    incr = 0
    @activity_array.each do |activity|
      if activity.name == 'Dinner & Lunch' || activity.name == 'Bar' || activity.name == 'Museums & Sites'
        incr += 1
      end
    end
    if incr == 3
      @activity_items['Museums & Sites'] = nil
      @activity_items['Dinner & Lunch'] = nil
      @activity_items['Bar'] = nil
    end

    # check if experiences have items
    n = 0
    @experiences.each do |experience|
      n += 1 unless experience.items.empty?
    end

    # for each activity, call yelp index api to get a list of items per activity category
    if n.zero?
      @activity_array.each do |activity|

        @items = []
        @item_categories.each do |category|
          next if activity.name != category.activity_reference

          items = YelpApiService.new(
            location: @city,
            radius: 10_000,
            category: category.name,
            price_range: @price_range
          ).call
          @items << items

          # create an array of 4 attributes to be added to an item
          attributes = generate_attributes(@item_attributes, activity)

          # associate each item with an activity, category, and 4 attributes
          @items.flatten.each do |item|
            item.update!(activity: activity) if item.activity.nil?
            item.update!(item_category: category) if item.item_category.nil?
            item.update!(image_url: add_image(activity)) if item.image_url.nil?

            next if item.item_attributes.size > 4

            attributes.each do |attrs|
              item.item_attributes << attrs
            end
          end
        end

        @items = Item.all
        result = []
        @items.each do |i|
          result << i if activity.name == i.activity.name
        end
        @activity_items[activity.name] = result
      end

      # determine what items are assigned to each (out of 3) experiences

      @experience_items = YelpItemService.new(
        activity_array: @activity_array,
        activity_items: @activity_items,
        starts_at: @starts_at,
        ends_at: @ends_at
      ).call

      # append items to each experience
      @experience_items.each_with_index do |item_list, index|
        @search.experiences[index].items << item_list
      end
    end
  end

  def show
    @search = Search.find(params[:search_id])
    @experience = Experience.find(params[:id])

    @itinerary = calculate_date_schedule(@search, @experience)
  end

  private

  def set_experience
    @experience = Experience.find(params[:id])
  end

  def generate_attributes(item_attributes, activity)
    attribute_list = []
    item_attributes.each do |attribute|
      next if activity.name != attribute.activity_reference

      attribute_list << attribute
    end
    attributes = []
    attributes << attribute_list.sample(4)
    attributes.flatten!
  end

  def calculate_date_schedule(search, experience)
    itinerary = []
    itinerary << search.starts_at.strftime('%l:%M %p')
    activity_time = @search.starts_at.to_time
    travel_time = 30
    experience.items.each_with_index do |item, index|
      activity_time += item.activity.duration * 60
      itinerary << activity_time.strftime('%l:%M %p')
      if index < @experience.items.size - 1
        activity_time += travel_time * 60
        itinerary << activity_time.strftime('%l:%M %p')
      end
    end
    itinerary
  end

  def reorder_hash(activity_items, activity_items_reordered)
    activity_items.each do |key, value|
      if key == 'Museums & Sites' && activity_items_reordered.size.zero?
        activity_items_reordered['Museums & Sites'] = value
        reorder_hash(activity_items, activity_items_reordered)
      elsif key == 'Dinner & Lunch' && activity_items_reordered.size == 1
        activity_items_reordered['Dinner & Lunch'] = value
        reorder_hash(activity_items, activity_items_reordered)
      elsif key == 'Bar' && activity_items_reordered.size == 2
        activity_items_reordered['Bar'] = value
        return activity_items_reordered
      end
    end
  end

  def add_image(activity)
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
      'https://images.unsplash.com/photo-1586884542514-f6bef0283446',
      'https://images.unsplash.com/photo-1584652868574-0669f4292976',
      'https://images.unsplash.com/photo-1566099191530-598e878ebd8b',
      'https://images.unsplash.com/photo-1580539924857-755cdc6aa3c2',
      'https://images.unsplash.com/photo-1566127444941-8e124ffbc59e'
    ]
    return restaurant_images.sample if activity.name == 'Dinner & Lunch'
    return bar_images.sample if activity.name == 'Bar'
    return museum_images.sample if activity.name == 'Museums & Sites'
  end
end
