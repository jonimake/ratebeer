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


end
