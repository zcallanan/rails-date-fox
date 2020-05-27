require "open-uri"

class YelpApiService
  API_KEY = ENV.fetch("YELP_API")
  BASE_URI = "https://api.yelp.com/v3/businesses/"

  def initialize(attrs = {})
    @location = attrs[:location]
    @radius = attrs[:radius]
    @category = attrs[:category]
    @price_range = attrs[:price_range]
    @items = []
  end

  def call
    url = BASE_URI + "search?location=#{@location}&radius=#{@radius}&categories=#{@category}"
    serialized_data = URI.open(url, "Authorization" => "Bearer #{API_KEY}").read
    data = JSON.parse(serialized_data)
    data = data["businesses"]
    data[0...5].each do |row|
      location = row["location"]
      address_string = "#{location["address1"]}, #{location["city"]} #{location["zip_code"]}"
      price = row["price"].nil? ? 1 : row["price"].size
      item = Item.find_by(name: row["name"])
      # Only make new request if the same item is not already in a DB
      if item.nil?
        # A member call will only be made if item does not already exist
        item = Item.create!(
          name: row["name"],
          address: address_string,
          rating: row["rating"],
          price_range: price,
          review_count: row["review_count"]
        )

        # Make a member request for item
        url = BASE_URI + row["id"]
        ser_data = URI.open(url, "Authorization" => "Bearer #{API_KEY}").read
        item_data = JSON.parse(ser_data)

        # Create item photos
        # item.photos.create!(item_data["photos"].map { |url| {url: url} })

        # Create opening hours
        if item_data.key?("hours")
          item_data["hours"][0]["open"].each do |h|
            item.operating_hours << OperatingHour.new(
              open_time: h["start"].sub(/^(\d{1,2})(\d{2})$/, '\1:\2').to_time,
              close_time: h["end"].sub(/^(\d{1,2})(\d{2})$/, '\1:\2').to_time,
              day: h["day"]
            )
          end
        end
        @items << item
      end
    rescue OpenURI::HTTPError
      puts "Request failed, carry on"
    end

    @items
  end
end
