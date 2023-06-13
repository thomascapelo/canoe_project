class Flight < ApplicationRecord
  belongs_to :airline
  belongs_to :origin_airport, class_name: 'Airport'
  belongs_to :destination_airport, class_name: 'Airport'
end
