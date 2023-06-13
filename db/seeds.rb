# Airports
san_francisco = Airport.create(code: "SFO", name: "San Francisco International Airport", city: "San Francisco", country: "United States")
los_angeles = Airport.create(code: "LAX", name: "Los Angeles International Airport", city: "Los Angeles", country: "United States")
new_york = Airport.create(code: "JFK", name: "John F. Kennedy International Airport", city: "New York", country: "United States")
london = Airport.create(code: "LHR", name: "London Heathrow Airport", city: "London", country: "United Kingdom")
puts "Airports created"

# Airlines
ua = Airline.create(name: "United Airlines")
aa = Airline.create(name: "American Airlines")
ba = Airline.create(name: "British Airways")
da = Airline.create(name: "Delta Airlines")
puts "Airlines created"

# Flights
flight_1 = Flight.create(departure_date: DateTime.new(2021, 9, 1, 8, 0, 0), arrival_date: DateTime.new(2021, 9, 1, 9, 0, 0), departure_city: "San Francisco", arrival_city: "Los Angeles", price: 100, airline_id: aa.id, origin_airport_id: san_francisco.id, destination_airport_id: los_angeles.id)
flight_2 = Flight.create(departure_date: DateTime.new(2023, 10, 1, 8, 0, 0), arrival_date: DateTime.new(2023, 12, 1, 9, 0, 0), departure_city: "Los Angeles", arrival_city: "London", price: 300, airline_id: ba.id, origin_airport_id: san_francisco.id, destination_airport_id: london.id)
flight_3 = Flight.create(departure_date: DateTime.new(2023, 10, 1, 8, 0, 0), arrival_date: DateTime.new(2023, 12, 1, 9, 0, 0), departure_city: "New York", arrival_city: "London", price: 300, airline_id: ba.id, origin_airport_id: new_york.id, destination_airport_id: london.id)
puts "Flights created"

# Users
john_do = User.create(email: "john.do@gmail.com", password: "password", name: "John Doe")
lisa_smith = User.create(email: "lisa.smith@gmail.com", password: "password", name: "Lisa Smith")
gigi_lamoroso = User.create(email: "gigi.lamoroso@gmail.com,", password: "password", name: "Gigi Lamoroso")
puts "Users created"

# Bookings
Booking.create(seat_number: 1, bagage: "hand", flight_id: flight_1.id, user_id: john_do.id)
Booking.create(seat_number: 2, bagage: "hand", flight_id: flight_2.id, user_id: lisa_smith.id)
Booking.create(seat_number: 3, bagage: "hand", flight_id: flight_3.id, user_id: gigi_lamoroso.id)
puts "Bookings created"
