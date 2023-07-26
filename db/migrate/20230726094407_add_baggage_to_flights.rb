class AddBaggageToFlights < ActiveRecord::Migration[7.0]
  def change
    add_column :flights, :includes_baggage, :boolean
  end
end
