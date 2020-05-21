class ActivitiesController < ApplicationController
  before_action :set_search

  def edit
    @activities = Activity.all
  end

  private 
  
  def set_search
    @search = Search.find(params[:search_id])
  end
end
