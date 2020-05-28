class SearchesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[new create]

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
          activity = Activity.find(activity_id)
          # remove item from experience
          item.destroy

          item_list = []
          @items.each do |x|
            # build a list of items for the activity that lost an item
            next if x.activity_id != activity_id

            item_list << x
          end
          new_item = sample_item(item_list, experience_item_array)

          if activity.name == 'Bar'
            new_item.update!(image_url: nil, long_description: nil)
            new_item.update!(image_url: add_image(activity, 4)) if new_item.image_url.nil?
            new_item.update!(long_description: long_description(activity, 3, new_item)) if new_item.long_description.nil?
            new_item.update!(priority: 3) if new_item.priority != 3
          elsif activity.name == 'Dinner & Lunch'
            new_item.update!(image_url: nil, long_description: nil)
            new_item.update!(image_url: add_image(activity, 3)) if new_item.image_url.nil?
            new_item.update!(long_description: long_description(activity, 3, new_item)) if new_item.long_description.nil?
            new_item.update!(priority: 2) if new_item.priority != 2
          elsif activity.name == 'Museums & Sites'
            new_item.update!(image_url: nil, long_description: nil)
            new_item.update!(image_url: add_image(activity, 3)) if new_item.image_url.nil?
            new_item.update!(long_description: long_description(activity, 3, new_item)) if new_item.long_description.nil?
            new_item.update!(priority: 1) if new_item.priority != 1
          end

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

  def long_description(activity, index, item)
    bar_descriptions = [
      "#{item.name} has been a favorite go to place for the people of Munich for over 20 years. Situated in the center of Munich, it is known for its carefully crafted drinks, classy atmosphere and outstanding service.",
      "#{item.name} harkens back to the romantic nostalgia of a forgotten time. A time when neighbors gathered to share their stories over good drinks – make sure to ask the barkeeper for the most recent creations in this hidden gem.",
      "#{item.name} is very refreshing, simple, yet elegant. If you’re lucky, you’ll catch one of their live music acts. Well known for its wide range of cocktails, the barfood can compete with some of the restaurants in the city as well.",
      "#{item.name} will immediately make you feel welcome with its cozy interior and friendly service. The best seats are at the bar because watching the barkeepers do their magic on the cocktails is worth the drinks already."
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
