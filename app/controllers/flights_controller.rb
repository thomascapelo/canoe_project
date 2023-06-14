class FlightsController < ApplicationController

  def search_results
    @flights = Flight.where(search_params)

    render 'search_results'
    # redirect_to search_flights_path
  end

  # def show
  #   @flight = Flight.find(params[:id])
  # end

  private

  def search_params
    params.permit(:departure_city, :arrival_city, :departure_date, :arrival_date)
  end
  
end
