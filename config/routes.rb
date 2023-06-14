Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")


  root "flights#index"

   # Airlines
   resources :airlines, only: [:index, :show]

   # Flights
   resources :flights, only: [:index, :show]
 
   # Bookings
   resources :bookings, only: [:new, :create, :show]
 
   # Users
   resources :users, only: [:new, :create]
 
   # Custom Routes
   get '/search', to: 'flights#search', as: 'flight_search'
end
