module RatingAverage
  extend ActiveSupport::Concern

  included do
    has_many :ratings
  end

  def average_rating
    ratings.average(:score)
  end



end
