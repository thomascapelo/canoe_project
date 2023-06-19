require 'net/http'
require 'json'

class FlightsController < ApplicationController  
  def search_results
    search_params # Call the method to set the instance variables
  
    access_token = get_access_token('E3QJBG9aB36ZF3tKCopetWORIvV7NYAC', 'Cu94OhFnMVAWGuJo')
    if access_token.nil?
      flash[:alert] = 'Failed to retrieve access token.'
      redirect_to root_path and return
    end
  
    logger.debug "Access Token: #{access_token}"
    logger.debug "Departure City: #{@departure_city}"
    logger.debug "Arrival City: #{@arrival_city}"
    logger.debug "Departure Date: #{@departure_date}"
    logger.debug "Return Date: #{@return_date}"
    logger.debug "Adults: #{@adults}"
  
    @flights = search_flights(@departure_city, @arrival_city, @departure_date, @return_date, @adults, access_token)
  
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

  def search_flights(origin, destination, departure_date, return_date, adults, access_token)
    uri = URI("https://test.api.amadeus.com/v2/shopping/flight-offers?originLocationCode=#{origin}&destinationLocationCode=#{destination}&departureDate=#{departure_date.strftime('%Y-%m-%d')}&returnDate=#{return_date.strftime('%Y-%m-%d')}&adults=#{adults}")  
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
  
    request = Net::HTTP::Get.new(uri)
    request['Authorization'] = "Bearer #{access_token}"
  
    response = http.request(request)
  
    puts "Response Code: #{response.code}"
    puts "Response Body: #{response.body}"
  
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
        flight.price = flight_offer['price']['total'].to_f # Convert the 'total' value to float
        flight.itineraries = flight_offer['itineraries'] # Add itineraries data to the flight object
        flights << flight
      end
  
      return flights
    else
      flash[:alert] = 'There was an error with your search. Please try again.'
      return []
    end
  end
  
  
  
  
  def calculate_flight_time(departure_date, arrival_date)
    flight_time = (arrival_date - departure_date) / 1.hour
    flight_time.round(2)
  end

  def search_params
    @departure_city = params[:departure_city]
    @arrival_city = params[:arrival_city]
    @departure_date = Date.parse(params[:departure_date]).beginning_of_day
    @return_date = Date.parse(params[:return_date]).beginning_of_day
    @adults = params[:adults].to_i
  end
  
end
