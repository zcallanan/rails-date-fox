class SearchesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[new]

  def new
    @search = Search.new
    @activities = Activity.all

  end

  def create
    @search = Search.new
    @search.user = current_user

    if @search.save
      # assign each experience to the user's @search
      3.times do
        experience = Experience.create!
        @search.experiences << experience
      end
      redirect_to cities_path(@search)
    else
      render :new
    end
  end

  def update
    @search = Search.find(params[:id])
    url = Rails.application.routes.recognize_path(request.referrer)

    unless params[:activity_ids].nil?
      @search.activities.destroy_all
      # Creating the search activities for a given search
      params[:activity_ids].each do |a|
        SearchActivity.create(search: @search, activity: Activity.find(a.to_i)) unless a == ""
      end
    end


    if @search.update!(search_params)
    #   if @search.activities.empty?
    #     raise
    #     redirect_to activities_path(@search)
    #   elsif @search.price_range == 0
    #     redirect_to price_ranges_path(@search)
    #   else
    #     # redirect_to experience_path(@search)
    #     redirect_to search_experiences_path(@search)
    #   end
    # else
    #   # redirect_to experience_path(@search)
    #   redirect_to search_experiences_path(@search)
      if url[:controller] == 'cities'
        redirect_to date_times_path(@search)
      end

      if url[:controller] == 'date_times'
        redirect_to activities_path(@search)
      end

      if url[:controller] == 'activities'
        redirect_to price_ranges_path(@search)
      end

      if url[:controller] == 'price_ranges'
        redirect_to search_experiences_path(@search)
      end
    end
  end

  def refresh
    @search = Search.find(params[:id])
    @items = Item.all
    @item = Item.find(params[:item_id])
    experience_item_array = []
    activity_id = nil
    new_item = nil
    @search.experiences.each do |experience|
      experience.items.each do |item|
        # if the item to be removed is found
        if item == @item
          # capture the item's activity
          activity_id = item.activity_id
          # remove item from experience
          item.destroy

          item_list = []
          @items.each do |x|
            # build a list of items for the activity that lost an item
            next if x.activity_id != activity_id

            item_list << x
          end
          new_item = sample_item(item_list, experience_item_array)
          experience.items << new_item
        end
      end
    end

    redirect_to search_experiences_path(@search)

    # item_card = render_to_string(
    #         partial: 'experiences/item-card',
    #         locals: { item: new_item, searches: @search }
    #       )

    # respond_to do |format|
    #   format.html
    #   format.json { render json: { item: item_card } }
    # end
  end

  private

  def sample_item(item_list, experience_item_array)
    # pick a random item for an activity
    new_item = item_list.sample
    # if the new item is a dupe, return false, else return item
    experience_item_array.each do |item|
      sample_item(item_list, experience_item_array) if new_item == item
    end
    new_item
  end

  def search_params
    params.require(:search).permit(:city, :starts_at, :ends_at, :price_range, activity_ids: [])
  end

end

# create controllers:
# ------------------------
# create new search with a city
# -> if search saves redirect to edit page with starts_at and ends_at (new controller)
# -> only edit and update action in step-controllers
# starts_at and ends_at controller
# -> if search saves redirect to edit page with price_range
# price_range controller
# -> if save redirect to edit page with activities
# activities controller
# -> if save, show results in experiences
#
# SKip-button to show all experiences (in one city or in all available?!)
