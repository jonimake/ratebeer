class Brewery < ActiveRecord::Base
  validate :validate_year
  include RatingAverage

  has_many :beers
  has_many :ratings, through: :beers

  scope :active, -> { where active:true }
  scope :retired, -> { where active:[nil,false] }

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


  def self.top(n)
    sorted_by_rating_in_desc_order = Brewery.all.sort_by{ |b| -(b.average_rating||0) }
    # palauta listalta parhaat n kappaletta
    # miten? ks. http://www.ruby-doc.org/core-2.1.0/Array.html
    sorted_by_rating_in_desc_order.slice(0..n)
  end

  def to_s
    name
  end

end
