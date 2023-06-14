class FlightsController < ApplicationController

  def search
    @flights = Flight.search(search_params)

    redirect_to search_path
  end

  
  private
  
  def search_params
    params.permit(:origin, :destination, :departure_date, :arrival_date, :passengers)
  end
  # def show
  #   @flight = Flight.find(params[:id])
  # end
end
