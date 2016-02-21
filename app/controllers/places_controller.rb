class PlacesController < ApplicationController
  def index
  end

  def show
    all_places = BeermappingApi.places_in(params[:city])
    @place = all_places.select{|p| p.id == params[:id]}.first
    if @place.nil? then
      @place = Place.new
    end
  end

  def search
    @places = BeermappingApi.places_in(params[:city])
    @city = params[:city]
    if @places.empty?
      redirect_to places_path, notice: "No locations in #{params[:city]}"
    else
      render :index
    end
  end
end