class DateTimesController < ApplicationController
  before_action :set_search

  def edit
  end

  private 
  
  def set_search
    @search = Search.find(params[:search_id])
  end
end
