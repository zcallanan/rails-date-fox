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

    # check if experiences have items
    n = 0
    @experiences.each do |experience|
      n += 1 unless experience.items.empty?
    end

    # for each activity, call yelp index api to get a list of items per activity category

    if n.zero?

      @activity_array.each do |activity|
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

        # hash where {activity.name => array of items for that activity }
        @activity_items[activity.name] = @items.flatten
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
    itinerary << search.starts_at.strftime('%I:%M %p')
    activity_time = @search.starts_at.to_time
    travel_time = 30
    experience.items.each_with_index do |item, index|
      activity_time += item.activity.duration * 60
      itinerary << activity_time.strftime('%I:%M %p')
      if index < @experience.items.size - 1
        activity_time += travel_time * 60
        itinerary << activity_time.strftime('%I:%M %p')
      end
    end
    itinerary
  end
end
