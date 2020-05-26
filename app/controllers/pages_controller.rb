class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :home
  def home
  end

  def booking_test
  end
  
end
