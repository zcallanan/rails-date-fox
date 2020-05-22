class ExperiencesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]
  before_action :set_experience, only: %i[show]

  def index
    @search = Search.find(params[:search_id])
    @items = []
    @search.experiences = []

    @city = @search.city
    @price_range = @search.price_range
    @starts_at = @search.starts_at

    @ends_at = @search.ends_at
    @activity_array = []
    @activity_array = @search.activities


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

    @experience_items = []
    @experience_items = YelpItemService.new(
      activity_array: @activity_array,
      activity_items: @activity_items,
      starts_at: @starts_at,
      ends_at: @ends_at
    ).call

    3.times do
      experience = Experience.create!
      @search.experiences << experience
    end

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
