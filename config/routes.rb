Rails.application.routes.draw do
  get 'root/index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")


  root "flights#index"

   # Airlines
   resources :airlines, only: [:index, :show]

   # Flights
   resources :flights, only: [:index, :show, :search_results]
   get 'search_results', to: 'flights#search_results', as: 'search_results'
 
   # Bookings
   resources :bookings, only: [:new, :create, :show]
 
   # Users
   resources :users, only: [:new, :create]

end
