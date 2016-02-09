require 'rails_helper'

include Helpers

describe "Beers" do
  let!(:brewery) { FactoryGirl.create :brewery, name:"Koff", id: 666 }
  let!(:user) { FactoryGirl.create :user }

  before :each do
    sign_in(username:"Pekka", password:"Foobar1")
  end

  it "allows users to add new beers" do
    visit new_beer_path

    select('IPA', from:'beer[style]')
    select('Koff', from:'beer[brewery_id]')
    fill_in('beer[name]', with:'test IPA beer')

    expect{
      click_button('Create Beer')
    }.to change{Beer.count}.by(1)
  end

  it "doesn't allow users to add beers without a name" do
    visit new_beer_path

    select('IPA', from:'beer[style]')
    select('Koff', from:'beer[brewery_id]')
    fill_in('beer[name]', with:'')

    expect{
      click_button('Create Beer')
    }.to change{Beer.count}.by(0)
    expect(page).to have_content "Name can't be blank"
  end

end