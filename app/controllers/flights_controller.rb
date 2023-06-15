require 'net/http'
require 'json'

class FlightsController < ApplicationController  
  def search_results
    search_params # Call the method to set the instance variables

    @outbound_flights = search_flights(@departure_city, @arrival_city, @departure_date)
    @return_flights = search_flights(@arrival_city, @departure_city, @return_date)

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

  def search_flights(origin, destination, date)
    api_key = 'E3QJBG9aB36ZF3tKCopetWORIvV7NYAC'
    api_secret = 'Cu94OhFnMVAWGuJo'

    uri = URI("https://api.amadeus.com/v2/shopping/flight-offers?originLocationCode=#{origin}&destinationLocationCode=#{destination}&departureDate=#{date}")

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(uri)
    request['Authorization'] = "Bearer #{api_key}:#{api_secret}"

    response = http.request(request)

    if response.code.to_i == 200
      flight_offers = JSON.parse(response.body)
      # Process the flight offers and return the flights
    else
      # Handle error
      flash[:alert] = 'There was an error with your search. Please try again.'
      [] # Return an empty array in case of error
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
