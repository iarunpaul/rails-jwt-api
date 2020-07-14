Rails.application.routes.draw do
  resource :hotels, except: :destroy
  post "delete_hotel", to: "hotels#destroy"
  post "bookings_in_hotel", to: "hotels#bookings"
  resource :bookings
  post "cancel_booking", to: "bookings#cancel_booking"
  post "checkout", to: "bookings#checkout"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resource :users, only: [:create, :update]
  post "/login", to: "users#login"
  get "/current_user", to: "users#current_user"
  post "/delete_user", to: "users#destroy"

end
