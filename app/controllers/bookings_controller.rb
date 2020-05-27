class BookingsController < ApplicationController
  def show
    @experience = Experience.find(params[:experience_id])
    @items = @experience.items
    @booking = Booking.find(params[:id])
    @search = @experience.searches.first
    @itinerary = calculate_date_schedule(@search, @experience)
  end

  def create
    @experience = Experience.find(params[:experience_id])
    @booking = Booking.new
    @booking.experience = @experience
    @booking.user = current_user
    @booking.save

    redirect_to experience_booking_path(@experience, @booking)
  end

  private

  ### TO DO - refactor to concerns

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
end
