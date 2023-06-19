class AddItinerariesToFlights < ActiveRecord::Migration[7.0]
  def change
    add_column :flights, :itineraries, :text
  end
end
