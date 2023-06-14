class FlightsController < ApplicationController

  def search
    @flights = Flight.search_flights(search_params)

    # redirect_to search_flights_path
    render 'search_results'
  end

  # def show
  #   @flight = Flight.find(params[:id])
  # end

  private

  def search_params
    params.permit(:origin, :destination, :departure_date, :arrival_date, :passengers)
  end
end
