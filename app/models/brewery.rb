class Brewery < ActiveRecord::Base
  include RatingAverage

  has_many :beers
  has_many :ratings, through: :beers
end
