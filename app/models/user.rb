class User < ActiveRecord::Base
  include RatingAverage

  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings

  has_many :memberships, -> {where confirmed: true}
  has_many :membership_applications, -> {where confirmed: false}, class_name: 'Membership'
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
    beers
        .joins(:ratings, :style)
        .group(:style).limit(1)
        .order("average_ratings_score desc")
        .average("ratings.score").first.first
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

  def self.top(n)
    sorted_by_rating_in_desc_order = User.all.sort_by{ |u| -(u.ratings.count||0) }
    # palauta listalta parhaat n kappaletta
    # miten? ks. http://www.ruby-doc.org/core-2.1.0/Array.html
    sorted_by_rating_in_desc_order.slice(0..n)
  end

  def to_s
    username
  end
end
