class FlightsController < ApplicationController

  def search
    @flights = Flight.search_flights(search_params)
  end

  private

  def search_params
    params.permit(:origin, :destination, :departure_date, :arrival_date, :passengers)
  end
end
