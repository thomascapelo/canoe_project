class Flight < ApplicationRecord
  belongs_to :airline
  belongs_to :origin_airport, class_name: 'Airport'
  belongs_to :destination_airport, class_name: 'Airport'
  has_many :bookings

  def self.search_flights(search_params)
    where(search_params)
  end
end
