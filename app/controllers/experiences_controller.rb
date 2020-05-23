class ExperiencesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]
  before_action :set_experience, only: %i[show]

  def index
    @items = []
    @activity_items = {}
    @activity_array = []
    @experience_items = []
    @item_categories = ItemCategory.all

    # form values
    @search = Search.find(params[:search_id])
    @search.experiences = [] # remove any previous experiences tied to this search
    @city = @search.city
    @price_range = @search.price_range
    @starts_at = @search.starts_at
    @ends_at = @search.ends_at
    @activity_array = @search.activities

    # for each activity, call yelp index api to get a list of items per activity category

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

        # associate each item with an activity & category

        @items.flatten.each do |item|
          item.update!(activity: activity, item_category: category)
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

    # assign each experience to the user's @search
    3.times do
      experience = Experience.create!
      @search.experiences << experience
    end

    # append items to each experience
    @experience_items.each_with_index do |item_list, index|
      @search.experiences[index].items << item_list
    end
  end

  def show
    @experience = Experience.find(params[:id])

  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end

  def set_experience
    @experience = Experience.find(params[:id])
  end
end
