class User < ActiveRecord::Base
  include RatingAverage

  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings

  has_many :memberships
  has_many :beer_clubs, -> {uniq},through: :memberships

  validates :username, uniqueness: true,
            length: { minimum: 3 }

  validates :password, format: {with: /[A-Z]{1,}/, message: "requires at least one capital letter." }
  validates :password, format: {with: /[0-9]{1,}/, message: "requires at least one number." }
  validates :password, length: {minimum: 4}

  has_secure_password

  def favourite_beer
    return nil if ratings.empty?   # palautetaan nil jos reittauksia ei ole
    ratings.order(score: :desc).limit(1).first.beer
  end

  def favourite_style
    return nil if ratings.empty?
    ratings.joins(:beer).group(:style).limit(1).order("average_score desc").average(:score).keys.first
  end

  def favourite_brewery
    return nil if ratings.empty?
    beers
        .joins(:brewery, :ratings)
        .group(:brewery).limit(1)
        .order("average_ratings_score desc")
        .average("ratings.score")
        .keys.first
  end
end
