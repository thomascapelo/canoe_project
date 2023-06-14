class FlightsController < ApplicationController  
  def search_results
    @departure_city = params[:departure_city]
    @arrival_city = params[:arrival_city]
    @departure_date = Date.parse(params[:departure_date]).beginning_of_day
    @return_date = Date.parse(params[:return_date]).beginning_of_day

    @outbound_flights = Flight.where(
      departure_city: @departure_city,
      arrival_city: @arrival_city,
      departure_date: @departure_date..@departure_date.end_of_day
    )

    @return_flights = Flight.where(
      departure_city: @arrival_city,
      arrival_city: @departure_city,
      departure_date: @return_date..@return_date.end_of_day
    )

    @flights = @outbound_flights + @return_flights

    render 'search_results'
  end

  private

  def search_params
    params.permit(:departure_city, :arrival_city)
          .merge(departure_date: Date.parse(params[:departure_date]).beginning_of_day..Date.parse(params[:departure_date]).end_of_day)
          .merge(return_date: Date.parse(params[:return_date]).beginning_of_day..Date.parse(params[:return_date]).end_of_day)
  end
end
