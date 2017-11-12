class Department < ApplicationRecord
  SCRAPE_SOURCE_URL = 'http://www.corcoran.com/nyc/Search/Listings?SaleType=Rent'

  def self.scrape_from_online
    url = SCRAPE_SOURCE_URL

    loop do
      puts "Starting fetch #{url}"
      page = PageParse.new(url)

      page.select_addresses.each do |address|
        self.create(address: address)
      end

      next_page_url = page.next_page_url
      break unless next_page_url.present?
      url = "http://www.corcoran.com/#{next_page_url}"

      sleep 3
    end
  end


  GEOCODE_API_URL = 'https://maps.google.cn/maps/api/geocode/json'

  def get_geo
    key = ENV['GOOGLE_API_KEY']
    raise 'Google API key not set.' unless key

    uri = URI(GEOCODE_API_URL)
    uri.query = URI.encode_www_form({ address: "#{address},NEW YORK", key: key })

    puts "Start request #{uri.to_s}"
    parse_geo_api_res(Net::HTTP.get(uri))
  rescue Net::OpenTimeout
    nil
  end

  private
  def parse_geo_api_res(response_body)
    response = JSON.parse(response_body)
    res_location = response['results']&.first.dig('geometry', 'location')
    return unless res_location.present?

    self.latitude = res_location['lat']
    self.longitude = res_location['lng']
    save
  rescue JSON::ParserError
    nil
  end
end
