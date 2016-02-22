require 'rails_helper'

include Helpers

describe "Logged in user" do
  let!(:user) { FactoryGirl.create :user }
  let!(:anotheruser) { FactoryGirl.create :anotheruser }
  let(:fullers){FactoryGirl.create(:brewery, name:"Fuller's")}
  let(:koff){FactoryGirl.create(:brewery, name:"Koff")}
  let(:stadi){FactoryGirl.create(:brewery, name:"Stadin Panimo")}
  let(:esb){FactoryGirl.create(:style, name: "ESB")}
  let(:indianPaleAle){FactoryGirl.create(:style, name:"Indian Pale Ale")}
  let(:ipa){FactoryGirl.create(:style, name:"IPA")}
  let(:lager){FactoryGirl.create(:style, name:"Lager")}

  describe "with lots of ratings" do
    before :each do
      beer = FactoryGirl.create(:beer, style: esb, brewery: fullers)
      ipabeer = FactoryGirl.create(:beer, style: indianPaleAle, brewery: fullers)
      FactoryGirl.create(:rating, score:12, beer:beer, user:user)
      FactoryGirl.create(:rating, score:15, beer:beer, user:user)
      FactoryGirl.create(:rating, score:35, beer:beer, user:user)

      FactoryGirl.create(:rating, score:12, beer:beer, user:anotheruser)
      FactoryGirl.create(:rating, score:15, beer:beer, user:anotheruser)

      stadiIpa = FactoryGirl.create(:beer, style: ipa, brewery: stadi)
      FactoryGirl.create(:rating, score:2, beer:stadiIpa, user:user)
      FactoryGirl.create(:rating, score:50, beer:stadiIpa, user:user)
      FactoryGirl.create(:rating, score:8, beer:stadiIpa, user:user)

      koffLager = FactoryGirl.create(:beer, style: lager, brewery: koff)
      FactoryGirl.create(:rating, score:2, beer:koffLager , user:user)
      FactoryGirl.create(:rating, score:10, beer:koffLager , user:user)
      FactoryGirl.create(:rating, score:8, beer:koffLager , user:user)
      sign_in(username:"Pekka", password:"Foobar1")
    end

    it "ratings should be visible on user page" do
      expect(page).to have_content "Has made 9 ratings"
      expect(page).to have_content "anonymous 12 delete"
      expect(page).to have_content "anonymous 15 delete"
      expect(page).to have_content "anonymous 2 delete"
    end

    it "should be possible to delete own rating" do
      expect{
        page.find(:xpath, "//a[@href='/ratings/1']").click
      }.to change{Rating.count}.by(-1)
    end

    it "should have favourite brewery" do
      expect(page).to have_content "Favourite brewery: Fuller's"
    end

    it "should have favoutire beer style" do
      expect(page).to have_content "Favourite beer style: ESB"
    end
  end
end