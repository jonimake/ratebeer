require 'rails_helper'

describe "beerlist page" do

  before :all do
    self.use_transactional_fixtures = false
    WebMock.disable_net_connect!(allow_localhost:true)
  end

  before :each do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.start

    @brewery1 = FactoryGirl.create(:brewery, name: "Koff")
    @brewery2 = FactoryGirl.create(:brewery, name: "Schlenkerla")
    @brewery3 = FactoryGirl.create(:brewery, name: "Ayinger")
    @style1 = Style.create name: "Lager"
    @style2 = Style.create name: "Rauchbier"
    @style3 = Style.create name: "Weizen"
    @beer1 = FactoryGirl.create(:beer, name: "Nikolai", brewery: @brewery1, style: @style1)
    @beer2 = FactoryGirl.create(:beer, name: "Fastenbier", brewery: @brewery2, style: @style2)
    @beer3 = FactoryGirl.create(:beer, name: "Lechte Weisse", brewery: @brewery3, style: @style3)
  end

  after :each do
    DatabaseCleaner.clean
  end

  after :all do
    self.use_transactional_fixtures = true
  end

  it "shows a known beer", :js => true do
    visit beerlist_path
    find('table').find('tr:nth-child(2)')
    expect(page).to have_content "Nikolai"
  end
  it "shows beers alphabetically", :js => true do
    visit beerlist_path
    find('table').find('tr:nth-child(2)')
    a = page.all('tr')[1].text
    b = page.all('tr')[2].text
    c = page.all('tr')[3].text
    expect(a).to include "Fastenbier"
    expect(b).to include "Lechte Weisse"
    expect(c).to include "Nikolai"
  end

  it "sorts beers by brewery", :js => true do
    visit beerlist_path
    find('table').find('tr:nth-child(2)')
    click_link('brewery')

    a = page.all('tr')[3].text
    b = page.all('tr')[1].text
    c = page.all('tr')[2].text
    expect(a).to include "Fastenbier"
    expect(b).to include "Lechte Weisse"
    expect(c).to include "Nikolai"

  end

  it "sorts beers by style", :js => true do
    visit beerlist_path
    find('table').find('tr:nth-child(2)')
    click_link('style')

    a = page.all('tr')[1].text
    b = page.all('tr')[2].text
    c = page.all('tr')[3].text
    expect(a).to include "Nikolai"
    expect(b).to include "Fastenbier"
    expect(c).to include "Lechte Weisse"
  end
end