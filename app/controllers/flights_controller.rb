require 'net/http'
require 'uri'
require 'json'

class FlightsController < ApplicationController  

  helper_method :search_airlines_name, :search_arilines_logo

  def search_results
    search_params # Call the method to set the instance variables

    client_id = ENV['CLIENT_ID']
    client_secret = ENV['CLIENT_SECRET']

    access_token = get_access_token(client_id, client_secret)
    if access_token.nil?
      flash[:alert] = 'Failed to retrieve access token.'
      redirect_to root_path and return
    end

    @access_token = access_token

    @flights = search_flights(@departure_city, @arrival_city, @departure_date, @return_date, @adults, @travel_class, access_token)
  
    @flights.each do |flight|
      flight.flight_time = calculate_flight_time(flight.departure_date, flight.arrival_date)
    end
  
    logger.debug "Flights: #{@flights}"
    render 'search_results'
  end
  

####### PRIVATE METHOD #######

  private

  def get_access_token(client_id, client_secret)
    uri = URI('https://test.api.amadeus.com/v1/security/oauth2/token')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri.path)
    request.set_form_data(
      'grant_type' => 'client_credentials',
      'client_id' => client_id,
      'client_secret' => client_secret
    )

    response = http.request(request)

    if response.code == '200'
      access_token = JSON.parse(response.body)['access_token']
      # Store or use the access token as needed
      return access_token
    else
      # Handle the error case
      return nil
    end
  end

def search_flights(origin, destination, departure_date, return_date, adults, travel_class, access_token)
  departure_date_str = departure_date.strftime('%Y-%m-%d')

  max_results = 20

  if return_date.nil?
    # One-way flight search

    uri = URI("https://test.api.amadeus.com/v2/shopping/flight-offers?originLocationCode=#{origin}&destinationLocationCode=#{destination}&departureDate=#{departure_date_str}&adults=#{adults}&max=#{max_results}&currencyCode=EUR&travelClass=#{travel_class}")
  else
    return_date_str = return_date.strftime('%Y-%m-%d')
    # Round-trip flight search
    uri = URI("https://test.api.amadeus.com/v2/shopping/flight-offers?originLocationCode=#{origin}&destinationLocationCode=#{destination}&departureDate=#{departure_date_str}&returnDate=#{return_date_str}&adults=#{adults}&max=#{max_results}&currencyCode=EUR&travelClass=#{travel_class}")
  end

  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true

  request = Net::HTTP::Get.new(uri)
  request['Authorization'] = "Bearer #{access_token}"

  response = http.request(request)

  if response.code.to_i == 200
    flight_offers = JSON.parse(response.body)
    flights = []
  flight_offers['data'].each do |flight_offer|
    flight = Flight.new
    flight.departure_city = origin
    flight.arrival_city = destination
    flight.departure_date = Time.parse(flight_offer['itineraries'].first['segments'].first['departure']['at'])
    flight.arrival_date = Time.parse(flight_offer['itineraries'].first['segments'].last['arrival']['at'])
    flight.flight_time = flight_offer['itineraries'].first['duration']
    flight.price = flight_offer['price']['total'].to_f
    flight.itineraries = flight_offer['itineraries']

    # Get the allowed checked bags quantity for each segment
    allowed_checked_bags = {}
    flight_offer['travelerPricings'].each do |traveler_pricing|
      fare_details = traveler_pricing['fareDetailsBySegment']
      next if fare_details.nil?

      fare_details.each do |fare_detail|
        segment_id = fare_detail['segmentId']
        allowed_checked_bags[segment_id] = fare_detail['includedCheckedBags']['quantity']
      end
    end

    # Set the checked bags quantity for each segment
    flight.itineraries.each do |itinerary|
      segments = itinerary['segments']
      segments.each do |segment|
        segment_id = segment['id']
        checked_bags = allowed_checked_bags[segment_id] || 0 # Use 0 if the segment ID is not found in allowed_checked_bags
        segment['checkedBags'] = checked_bags
      end
    end

    flights << flight
  end

    return flights
  else
    flash[:alert] = 'There was an error with your search. Please try again.'
    return []
  end
end

    # # # SEARCH AIRLINE NAME IN API # # #
  def search_airlines_name(airline_code, access_token)
    uri = URI("https://test.api.amadeus.com/v1/reference-data/airlines?airlineCodes=#{airline_code}")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(uri)
    request['Authorization'] = "Bearer #{access_token}"

    response = http.request(request)

    if response.code == '200'
      airline_name = JSON.parse(response.body)['data'].first['businessName'].capitalize
          # Display the airline_name value in the console
      return airline_name
    end
  end

  # # # SEARCH AIRLINE LOGO IN API Clearbit # # #
  def search_airlines_logo(airline_company_name)
    url = URI("https://api.brandfetch.io/v2/brands/#{airline_company_name}.com")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(url)
    request["accept"] = 'application/json'
    request["Authorization"] = "Bearer #{ENV['BRANDFETCH_API_KEY']}"

    response = http.request(request)
    puts response.read_body
  end
  
  
  def calculate_flight_time(departure_date, arrival_date)
    flight_time = (arrival_date - departure_date) / 1.hour
    flight_time.round(2)
  end

  def search_params
    @departure_city = params[:departure_city]
    @arrival_city = params[:arrival_city]
    @departure_date = Date.strptime(params[:departure_date], '%Y-%m-%d').beginning_of_day
    @return_date = Date.strptime(params[:return_date], '%Y-%m-%d').beginning_of_day if params[:return_date].present?
    @adults = params[:adults].to_i
    @travel_class = params[:travel_class]
    @trip_type = params[:trip_type]
    @trip_type_value = case @trip_type
                     when 'round_trip'
                       'Round Trip'
                     when 'one_way'
                       'One Way'
                     else
                       'Unknown Trip Type'
                     end
  end
end
