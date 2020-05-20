class ExperiencesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index]

  def index
   
  end

  # this required?
  def show; end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end


end
