class BeerClub < ActiveRecord::Base

  has_many :memberships, -> { where confirmed: true }
  has_many :membership_applications, -> {where confirmed: false},
           class_name: 'Membership'
  has_many :members, -> {uniq}, through: :memberships, source: :user

end
