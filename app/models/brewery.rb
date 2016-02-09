class Brewery < ActiveRecord::Base
  validate :validate_year
  include RatingAverage

  has_many :beers
  has_many :ratings, through: :beers

  def validate_year()
    if year.nil?
      errors.add(:year, 'must be a number')
    else
      errors.add(:year, 'must be equal or greater than 1042') if year < 1042
      errors.add(:year, 'must be equal or less than current year') if year > Time.now.year
    end
  end
  validates :name, uniqueness: true,
            presence: true
end
