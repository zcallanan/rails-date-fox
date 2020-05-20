class ExperiencesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]

  def index
    @experiences = Experience.all

    #item_list
    # Calculate duration from search starts and ends datetime
    # With total duration, compare against duration of experience + travel time default to generate number of items
    # what activities you have selected 1 activity = 1 item per experience
    # select items with the best rating
    # add items to an array
    # If user wants a different item
    # @item = Item.find(params[:id])
  end

  def show; end

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


end
