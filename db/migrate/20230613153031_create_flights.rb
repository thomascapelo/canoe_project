class CreateFlights < ActiveRecord::Migration[7.0]
  def change
    create_table :flights do |t|
      t.datetime :departure_date
      t.datetime :arrival_date
      t.string :departure_city
      t.string :arrival_city
      t.float :price
      t.references :airline, null: false, foreign_key: true
      t.references :origin_airport, null: false, foreign_key: true
      t.references :destination_airport, null: false, foreign_key: true

      t.timestamps
    end
  end
end
