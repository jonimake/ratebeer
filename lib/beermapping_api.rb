class BeermappingApi

  def self.places_in(city)
    city = city.downcase
    Rails.cache.fetch(city, expires_in: 1.minute) { fetch_places_in(city) }
  end

  private

  def self.fetch_places_in(city)
    url = "http://beermapping.com/webservice/loccity/#{key}/"
    backup_url = "http://stark-oasis-9187.herokuapp.com/api/"
    response = HTTParty.get "#{url}#{ERB::Util.url_encode(city)}"
    if response.code != 200 or response.parsed_response == "Could not connect to mysql"
      response = HTTParty.get "#{backup_url}#{ERB::Util.url_encode(city)}"
    end
    return [] if response.parsed_response["bmp_locations"].nil?
    places = response.parsed_response["bmp_locations"]["location"]

    return [] if places.is_a?(Hash) and places['id'].nil?

    places = [places] if places.is_a?(Hash)
    places.map do | place |
      Place.new(place)
    end
  end

  def self.key
    raise "BM_API_KEY env variable not defined" if ENV['BM_API_KEY'].nil?
    ENV['BM_API_KEY']
  end
end