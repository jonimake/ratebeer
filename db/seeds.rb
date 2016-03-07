# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# style1 = Style.create! name:"ESB", description:"Truly the most special of bitters"
# style2 = Style.create! name:"Lager", description:"Lager desc"
#
# b1 = Brewery.create! name:"Koff", year:1897
# b2 = Brewery.create! name:"Malmgard", year:2001
# b3 = Brewery.create! name:"Weihenstephaner", year:1042
#
# b1.beers.create name:"Iso 3", style:style1, brewery:b1
# b1.beers.create name:"Karhu", style:style1, brewery:b2
# b1.beers.create name:"Tuplahumala", style:style1, brewery:b3
# b2.beers.create name:"Huvila ESB", style:style2, brewery:b1
# b2.beers.create name:"X Porter", style:style1, brewery:b2
# b3.beers.create name:"Hefeweizen", style:style1, brewery:b3
# b3.beers.create name:"Helles", style:style1, brewery:b1

users = 200           # jos koneesi on hidas, riittää esim 100
breweries = 100       # jos koneesi on hidas, riittää esim 50
beers_in_brewery = 40
ratings_per_user = 30

(1..users).each do |i|
  User.create! username:"user_#{i}", password:"Passwd1", password_confirmation:"Passwd1"
end

(1..breweries).each do |i|
  Brewery.create! name:"Brewery_#{i}", year:1900, active:true
end

bulk = Style.create! name:"Bulk", description:"cheap, not much taste"

Brewery.all.each do |b|
  n = rand(beers_in_brewery)
  (1..n).each do |i|
    beer = Beer.create! name:"Beer #{b.id} -- #{i}", style:bulk
    b.beers << beer
  end
end

User.all.each do |u|
  n = rand(ratings_per_user)
  beers = Beer.all.shuffle
  (1..n).each do |i|
    r = Rating.new score:(1+rand(50))
    beers[i].ratings << r
    u.ratings << r
  end
end