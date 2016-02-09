require 'rails_helper'

include Helpers

RSpec.describe User, type: :model do
  it "has the username set correctly" do
    user = User.new username:"Pekka"

    expect(user.username).to eq "Pekka"
  end

  it "is not saved without a password" do
    user = User.create username:"Pekka"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  describe "with a proper password" do
    let(:user){ FactoryGirl.create(:user) }

    it "is saved" do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end

    it "and with two ratings, has the correct average rating" do
      user.ratings << FactoryGirl.create(:rating)
      user.ratings << FactoryGirl.create(:rating2)

      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
    end
  end

  describe "without a proper password" do
    let(:user){ User.create username:"Pekka", password:"password", password_confirmation:"password" }

    it "user was not saved" do
      expect(user).not_to be_valid
      expect(User.count).to eq(0)
    end
  end

  it "has method for determining the favorite_beer" do
    user = FactoryGirl.create(:user)
    expect(user).to respond_to(:favourite_beer)
  end

  it "without ratings does not have a favorite beer" do
    user = FactoryGirl.create(:user)
    expect(user.favourite_beer).to eq(nil)
  end

  describe "favourite beer" do
    let(:user){FactoryGirl.create(:user) }

    it "has method for determining one" do
      expect(user).to respond_to(:favourite_beer)
    end

    it "without ratings does not have one" do
      expect(user.favourite_beer).to eq(nil)
    end

    it "is the only rated if only one rating" do

      beer = FactoryGirl.create(:beer)
      rating = FactoryGirl.create(:rating, beer:beer, user:user)
      expect(user.favourite_beer).to eq(beer)
    end

    it "is the one with highest rating if several rated" do
      create_beers_with_ratings(user, 10, 15, 9)
      best = create_beer_with_rating(user, 25)
      expect(user.favourite_beer).to eq(best)
    end

  end

  describe "favourite style" do
    let(:user){FactoryGirl.create(:user) }

    it "is the one with highest rating if several rated" do

      create_beer_with_rating_and_style(user, 10, "kuravesi")
      create_beer_with_rating_and_style(user, 20, "koff")
      create_beer_with_rating_and_style(user, 30, "Extra Special Bitter")
      create_beer_with_rating_and_style(user, 20, "koff")
      expect(user.favourite_style).to eq("Extra Special Bitter")
    end
  end

  describe "favourite brewery" do
    let(:user){FactoryGirl.create(:user) }
    let(:brew1){FactoryGirl.create(:brewery, name:"Koff")}
    let(:brew2){FactoryGirl.create(:brewery, name:"Fuller's")}

    it "is the one with highest rating if several rated" do

      brew1.beers << create_beer_with_rating_and_style(user, 10, "kuravesi")
      brew1.beers << create_beer_with_rating_and_style(user, 30, "koff")
      brew2.beers << create_beer_with_rating_and_style(user, 30, "Extra Special Bitter")
      brew1.beers << create_beer_with_rating_and_style(user, 20, "koff")
      expect(user.favourite_brewery).to eq(brew2)
    end
  end

end
