require 'rails_helper'

include Helpers

describe "Beers" do
  let!(:user) { FactoryGirl.create :user }
  let!(:style) {FactoryGirl.create :style }

  before :each do
    sign_in(username:"Pekka", password:"Foobar1")

    beer = FactoryGirl.create(:beer, style:style)
    FactoryGirl.create(:rating, score:12, beer:beer, user:user)
    FactoryGirl.create(:rating, score:15, beer:beer, user:user)
    FactoryGirl.create(:rating, score:28, beer:beer, user:user)
  end

  describe "with three ratings" do
    it "number of ratings should be visible on page" do
      visit ratings_path
      expect(page).to have_content "Number of ratings: 3"
    end

    it "three ratings should be visible on ratings page" do
      visit ratings_path
      expect(page).to have_content "anonymous 12 Pekka"
      expect(page).to have_content "anonymous 15 Pekka"
      expect(page).to have_content "anonymous 28 Pekka"
    end
  end


end