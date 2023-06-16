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

    @outbound_flights = search_flights(@departure_city, @arrival_city, @departure_date, access_token)
    @return_flights = search_flights(@arrival_city, @departure_city, @return_date, access_token)

    @flights = @outbound_flights + @return_flights

    @outbound_flights.each do |flight|
      flight.flight_time = calculate_flight_time(flight.departure_date, flight.arrival_date)
    end

    @return_flights.each do |flight|
      flight.flight_time = calculate_flight_time(flight.departure_date, flight.arrival_date)
    end

    render 'search_results'
  end

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

  def search_flights(origin, destination, date, access_token)
    uri = URI("https://test.api.amadeus.com/v2/shopping/flight-offers?originLocationCode=#{origin}&destinationLocationCode=#{destination}&departureDate=#{date}&adults=1&nonStop=false&max=250")
  
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
        flight.arrival_date = Time.parse(flight_offer['itineraries'].first['segments'].first['arrival']['at'])
        flight.flight_time = flight_offer['itineraries'].first['duration']
        flight.price = flight_offer['price']
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
  end
end
