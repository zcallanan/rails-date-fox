class DateTimesController < ApplicationController
  before_action :set_search
  skip_before_action :authenticate_user!, only: %i[edit]

  def edit
    unless @search.present?
      @search = Search.new
    end
  end

  private

  def set_search
    @search = Search.find(params[:search_id])
  end
end
