json.array!(@breweries) do |brewery|
  json.extract! brewery, :id, :name, :year
  json.url brewery_url(brewery, format: :json)
  json.beers do
    json.array! brewery.beers, :id, :name, :style_id
  end
end
