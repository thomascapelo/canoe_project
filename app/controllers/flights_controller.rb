class FlightsController < ApplicationController

  def search_results
    @departure_city = params[:departure_city]
    @arrival_city = params[:arrival_city]

    @flights = Flight.where(search_params)

    render 'search_results'
    # redirect_to search_flights_path
  end

  # def show
  #   @flight = Flight.find(params[:id])
  # end

  private

  def search_params
    params.permit(:departure_city, :arrival_city)
          .merge(departure_date: Date.parse(params[:departure_date]).beginning_of_day..Date.parse(params[:departure_date]).end_of_day)
          .merge(arrival_date: Date.parse(params[:arrival_date]).beginning_of_day..Date.parse(params[:arrival_date]).end_of_day)
  end
  
  
end
