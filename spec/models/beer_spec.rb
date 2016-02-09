require 'rails_helper'

RSpec.describe Beer, type: :model do
  it "was saved with name and style" do
    beer = Beer.create name:"Karhu 3", style:"IPA"

    expect(beer).to be_valid
    expect(Beer.count).to eq 1
  end

  it "was not saved without a name" do
    beer = Beer.create style:"IPA"

    expect(beer).to_not be_valid
    expect(Beer.count).to eq 0
  end

  it "was not saved without a style" do
    beer = Beer.create name:"Karhu 3"

    expect(beer).to_not be_valid
    expect(Beer.count).to eq 0
  end
end
#oluen luonti onnistuu ja olut tallettuu kantaan jos oluella on nimi ja tyyli asetettuna
#oluen luonti ei onnistu (eli creatella ei synny validia oliota), jos sille ei anneta nimeä
#oluen luonti ei onnistu, jos sille ei määritellä tyyliä