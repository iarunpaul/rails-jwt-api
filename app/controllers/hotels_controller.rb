class HotelsController < ApplicationController

  # CREATE hotel as owner or admin
  # post '/hotels'
   def create
    if @current_user.admin? || @current_user.owner?
      hotel = Hotel.new(hotel_params)
      hotel.owner_id = @current_user.id if @current_user.owner?
      hotel.save!
      message = "You have created the hotel records successfully"
      respond_http(error: nil, message: message, hotel_created: hotel)
    else
      message = "You are not authorized to create a Hotel."
      respond_http(status: 403, error: :forbidden_error, message: message)
    end
  end

  # INDEX all the hotels for all users
  def index
    hotels = Hotel.all
    message = "Hotels List:"
    respond_http(error: nil, message: message, hotel_list: hotels)
  end

  # SHOW the hotels with the id
  def show
    hotel = Hotel.find(params[:id])
    message = "The hotel details:"
    respond_http(error: nil, message: message, hotel_details: hotel)
  end

  # UPDATE the hotel details as an admin or owner
  # put '/hotels'
  def update
    hotel = Hotel.find(params[:id])
    if @current_user.admin? || @current_user.id == hotel.owner_id
      params[:owner_id] = @current_user.id if @current_user.owner?
      hotel.update!(hotel_params)
      message = "The hotel #{hotel.name} has been updated."
      respond_http(error: nil, message: message, updated_hotel: hotel)
    else
      message = "You are not authorized to edit this Hotel."
      respond_http(status: 403, error: :forbidden_error, message: message)
    end
  end
  # DELETE a hotel if an admin or the user is the owner of the hotel
  # post '/delete_hotel'
  def destroy
    hotel = Hotel.find(params[:id])
    if @current_user.admin? || @current_user.id == hotel.owner_id
      hotel.delete
      message = "You have successfully deleted the Hotel #{hotel.name}'s records."
      respond_http(error: nil, message: message)
    else
      message = "You are not authorized to delete this Hotel reccord."
      respond_http(status: 403, error: :forbidden_error, message: message)
    end
  end

  def bookings
    bookings = Hotel.find(params[:id]).bookings
    message = "The list of bookings for the Hotel is:"
    respond_http(error: nil, message: message, hotel_bookings: bookings)
  end

  private
    def hotel_params
      params.permit(:name, :rating, :description, :rate, :owner_id)
    end
end
