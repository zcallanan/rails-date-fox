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

  private

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
