Rails.application.routes.draw do

  post 'auth/login', to: 'authentication#authenticate'
  post 'signup', to: 'users#create'

  resource :hotels, except: [:destroy, :show]
  post "delete_hotel", to: "hotels#destroy"
  post "bookings_in_hotel", to: "hotels#bookings"
  post "show_hotel", to: "hotels#show"
  get "hotels/index", to: "hotels#index"

  resource :bookings, except: :show
  post "cancel_booking", to: "bookings#cancel_booking"
  post "checkout", to: "bookings#checkout"
  get "bookings/list", to: "bookings#index"
  post "show_booking", to: "bookings#show"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # resource :users, only: [:create, :update, :show]
  # post "/login", to: "users#login"
  # get "/current_user", to: "users#current_user"
  # post "/delete_user", to: "users#destroy"

end
