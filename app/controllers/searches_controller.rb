class SearchesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index]

  def index
    @search = Search.new
    @activities = Activity.all
  end
  
end
