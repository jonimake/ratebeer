class Membership < ActiveRecord::Base
  belongs_to :user
  belongs_to :beer_club

  scope :confirmed, -> { where confirmed:true }
  scope :unconfirmed, -> { where confirmed:false }
end
