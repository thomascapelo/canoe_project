class Flight < ApplicationRecord
  belongs_to :airline
  belongs_to :origin_airport, class_name: 'Airport'
  belongs_to :destination_airport, class_name: 'Airport'
  has_many :bookings

  def formatted_departure_time
    departure_date.strftime('%I:%M %p')
  end

  def formatted_arrival_time
    arrival_date.strftime('%I:%M %p')
  end
  
  serialize :itineraries, JSON
end
