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
    n = 3
    @experiences.each do |experience|
      n -= 1 if experience.items.empty?
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

            next if item.item_attributes.size > 4

            attributes.each do |attrs|
              item.item_attributes << attrs
            end
          end
        end

        @items = Item.all
        result = []
        @items.each do |i|
          unless i.activity_id.nil?
            result << i if activity.name == i.activity.name
          end
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

      bar = 0
      restaurant = 0
      museum = 0
      @activity_array.each do |activity|
        @experience_items.flatten.each do |item|
          if activity.id == item.activity_id
            if activity.name == 'Bar'
              item.update!(image_url: nil, description: nil, long_description: nil)
              item.update!(image_url: add_image(activity, bar)) if item.image_url.nil?
              item.update!(description: add_description(activity, bar, item)) if item.description.nil?
              item.update!(long_description: long_description(activity, bar, item)) if item.long_description.nil?
              item.update!(priority: 3) if item.priority != 3
              bar += 1
            elsif activity.name == 'Dinner & Lunch'
              item.update!(image_url: nil, description: nil, long_description: nil)
              item.update!(image_url: add_image(activity, restaurant)) if item.image_url.nil?
              item.update!(description: add_description(activity, restaurant, item)) if item.description.nil?
              item.update!(long_description: long_description(activity, restaurant, item)) if item.long_description.nil?
              item.update!(priority: 2) if item.priority != 2
              restaurant += 1
            elsif activity.name == 'Museums & Sites'
              item.update!(image_url: nil, description: nil, long_description: nil)
              item.update!(image_url: add_image(activity, museum)) if item.image_url.nil?
              item.update!(description: add_description(activity, museum, item)) if item.description.nil?
              item.update!(long_description: long_description(activity, museum, item)) if item.long_description.nil?
              item.update!(priority: 1) if item.priority != 1
              museum += 1
            end

          end
        end
      end

      # append items to each experience
      @experience_items.each_with_index do |item_list, index|
        @search.experiences[index].items << item_list
      end
    end
    # order items
    @ordered_items = []
    @search.experiences.each do |experience|
      @ordered_items << experience.items.order(:priority)
    end
  end

  def show
    @search = Search.find(params[:search_id])
    @experience = Experience.find(params[:id])

    @ordered_items = @experience.items.order(:priority)

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

  def add_description(activity, index, item)
    bar_descriptions = [
      "#{item.name} in the heart of Munich is among local's favorites for state of the art drinks and atmosphere.",
      "#{item.name} is best know for its well crafted drinks and excellent service, and you will always find a fun crowd.",
      "#{item.name} boosts a special atmosphere that you will love once you enter. The drinks selection is among the city's finest."
    ]

    restaurant_descriptions = [
      "#{item.name} in one of Munich's most popular neighbourhoods delivers a quality of dishes that is hard to beat anywhere else in the city.",
      "#{item.name} has established a reputation for excellent food and service. Make sure to have one of their excellent wines!",
      "#{item.name} manages to combine a laid-back atmosphere with truly high-class service and a menu that will make you smile."
    ]

    museum_descriptions = [
      "#{item.name} is a great place to unwind and learn about various facets of Munich's past and present.",
      "#{item.name} is always a great place to discover and relax in the beautiful gardens nearby. Careful, it's romantic!",
      "#{item.name} could keep you busy for hours with its wide range of things to discover. But don't rush, you can always come back."
    ]

    return restaurant_descriptions[index] if activity.name == 'Dinner & Lunch'
    return bar_descriptions[index] if activity.name == 'Bar'
    return museum_descriptions[index] if activity.name == 'Museums & Sites'
  end

  def long_description(activity, index, item)
    bar_descriptions = [
      "#{item.name} has been a favorite go to place for the people of Munich for over 20 years. Situated in the center of Munich, it is known for its carefully crafted drinks, classy atmosphere and outstanding service.",
      "#{item.name} harkens back to the romantic nostalgia of a forgotten time. A time when neighbors gathered to share their stories over good drinks – make sure to ask the barkeeper for the most recent creations in this hidden gem.",
      "#{item.name} is very refreshing, simple, yet elegant. If you’re lucky, you’ll catch one of their live music acts. Well known for its wide range of cocktails, the barfood can compete with some of the restaurants in the city as well."
    ]

    restaurant_descriptions = [
      "#{item.name}, situated in one of Munich's most popular neighbourhoods, is known for both traditional dishes and changing modern fusion items on the menu. Make sure to come hungry, you will want to eat more than you can.",
      "#{item.name} has created rustic and elegant dishes that showcase the restaurant’s relationship with local farms and purveyors—speaking to time-honored techniques with a focus on offerings best shared with your significant other.",
      "#{item.name} offers nationally renowned steaks—dry aged and hand-cut on premises by the restaurant's own butchers—the freshest of seafood, creative sides and irresistible desserts prepared on-site every day. You cannot go wrong here!"
    ]

    museum_descriptions = [
      "#{item.name} is one of the most interesting places in Munich to go for some cultural education. With a wide range of digital gimmicks, the staff will surely keep you entertained and make the visit more fun than you may expect.",
      "#{item.name} is one of the most popular places in Munich to soak up a sophisticated atmosphere and learn about the city's past. Great restaurants and bars are closeby, making it a perfect place to make the most out of your weekend.",
      "#{item.name} is among the largest of its size and offers something for everyone. Close to a million visitors per year speak for itself. Make sure to book tickets in advance, especially on weekends the queues get very long."
    ]

    return restaurant_descriptions[index] if activity.name == 'Dinner & Lunch'
    return bar_descriptions[index] if activity.name == 'Bar'
    return museum_descriptions[index] if activity.name == 'Museums & Sites'
  end

  def add_image(activity, index)
    bar_images = [
      'https://images.unsplash.com/photo-1514933651103-005eec06c04b?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1491333078588-55b6733c7de6?ixlib=rb-1.2.1&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1529502669403-c073b74fcefb?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1436018626274-89acd1d6ec9d?ixlib=rb-1.2.1&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1534157458714-42b1e9cd5727?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop'
    ]

    restaurant_images = [
      'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1525610553991-2bede1a236e2?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1544739313-6fad02872377?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1589769105893-3cfe4c0c8851?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1587574293340-e0011c4e8ecf?ixlib=rb-1.2.1&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1563507466372-c61871fff681?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop'
    ]

    museum_images = [
      'https://images.unsplash.com/photo-1586884542514-f6bef0283446?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1566127444941-8e124ffbc59e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1584652868574-0669f4292976?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1566099191530-598e878ebd8b?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1580539924857-755cdc6aa3c2?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop'
    ]
    return restaurant_images[index] if activity.name == 'Dinner & Lunch'
    return bar_images[index] if activity.name == 'Bar'
    return museum_images[index] if activity.name == 'Museums & Sites'
  end
end
