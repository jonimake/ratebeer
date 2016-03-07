class RatingsController < ApplicationController
  before_action :set_rating, only: [:show, :edit, :update, :destroy]
  before_action :ensure_that_signed_in, except: [:index, :show]
  before_action :skip_if_cached, only:[:index]

  def invalidate_list_cache
    expire_fragment("ratingslist")
  end

  def skip_if_cached
    return render :index if fragment_exist?( "ratingslist"  )
  end

  # GET /ratings
  # GET /ratings.json

  #normi fragmet cachetus, beerissä on after_save:ssa ratingslist fragmentin invalidointi
  def index
    @ratings = Rating.all
    @top_breweries = Brewery.top 3
    @top_raters = User.top 3
    @top_beers = Beer.top 3
    @top_styles = Style.top 3
    @last_ratings = Rating.recent
  end

  def new
    @rating = Rating.new
    @beers = Beer.all
  end

  def create
    @rating = Rating.new params.require(:rating).permit(:score, :beer_id)

    if @rating.save
      invalidate_list_cache
      current_user.ratings << @rating
      redirect_to user_path current_user
    else
      @beers = Beer.all
      render :new
    end
  end

  def destroy
    invalidate_list_cache
    rating = Rating.find params[:id]
    rating.delete if current_user == rating.user
    redirect_to :back
  end

  private
  def set_rating
    @rating = Rating.find(params[:id])
  end

end