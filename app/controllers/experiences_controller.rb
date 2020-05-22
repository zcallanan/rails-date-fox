class ExperiencesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]
  before_action :set_experience, only: %i[show]

  def index
    @search = Search.find(params[:search_id])
    @items = []
    @experiences = Experience.all
    @search.experiences << @experiences.first
    test_price_range = 2

    @city = @search.city
    # @price_range = @search.price_range
    @price_range = test_price_range
    @starts_at = @search.starts_at
    @ends_at = @search.ends_at
    @activity_array = []
    @activity_array = @search.activities

    # need to create 3 experiences for the user at this point
    # n = 0
    # 3.times do
    #   n += 1
    #   Experience.create(
    #     starts_at: @starts_at,
    #     ends_at: @ends_at,
    #     name: "Experience #{n}"
    #   )
    # end
    @activity_items = {}
    @activity_array.each do |activity|
      activity.activity_categories.each do |category|
        items = YelpApiService.new(
          location: @city,
          radius: 10_000,
          category: category.name,
          price_range: @price_range
        ).call
        @items << items
      end
      @activity_items[activity.name] = @items.flatten
    end




    # submit form with nothing but a @search
    # get 1, or 2, or variable activities - 1 activity gets 1 item of duration X
    # if duration does allow all activities, then we need prioritize one activity over another
    ## this could hard coded
    # Restaurant Bar and something else
    # We know duration fits all of them
    # Get result

    #search.activities.name = @activity_array[...].name


    # @items = Item.where(
    #   'price_range = ? \
    #   AND search.activities = ?',
    #   @price_range
    # ).order(rating: :desc)






    # Filter item by city
    # Filter by duration
    ## Filter item by starts at
    ## Filter item by ends at
    ## Are they open?
    # Matches an activity

    ## Does the activity fit their duration?

    # Filter item by


    # sum = 0
    # @activity_array.each do |activity|
    #   sum += activity.duration
    # end
    # average_duration = sum / @activity_kinds.size


    # @items = Item.where("price_range = ?", "#{@price_range.size}").order(rating: :desc)
    # model would be...
    # scope :search_by_price_range, lambda { |price|
    #   where("price_range = ?", "#{price}")
    # }
    # controller/service
    # @items = @items.search_by_price_range(@price_range.size)




    # what activities you have selected 1 activity = 1 item per experience
    # Calculate duration from search starts and ends datetime
    # With total duration, compare against duration of experience + travel time default to generate number of items
    # filter by price first, then duration, then rating
    ## top average duration
    ## if it exceeds desired duration, remove 1 or go with lowest duration items
    # @message activity you are looking for exceeds your duration
    # select items with the best rating
    # add items to an array
    # If user wants a different item
    # @item = Item.find(params[:id])

    # form is sending params
    # filter items by price_range params
    # sort items by rating params
    # group items by activity type
    # randomly select one item per activity type and store in one of three arrays
    ## what activities selected, for each activity get top ranked items and store them in arrays
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
