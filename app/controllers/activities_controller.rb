class ActivitiesController < ApplicationController
  before_action :set_search
  skip_before_action :authenticate_user!, only: %i[edit]

  def edit
    @activities = Activity.all
  end

  private

  def set_search
    @search = Search.find(params[:search_id])
  end
end
