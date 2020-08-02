module V1
  class HotelsController < ApplicationController

    # CREATE hotel as owner or admin
    # post '/hotels'
    # @!method create(request)
    # @param request [Request] required: `name`, `rate`, `rating` and `owner_id`,
    #   if `admin` creates the hotel, elsif owner creates hotel
    #   `owner_id` is assigned as current_user `id`
    # @result [Response] it returns Json response with the created status and hotel details
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
    # get '/hotels/index'
    # @return [Response]
    # @note it lists all hotel irrespective to the user role
    def index
      hotels = Hotel.all
      paginated = hotels.paginate(page: params[:page], per_page: 10)
      # for active-record-serialized response
      # render json: paginated, status: 200
      message = "Hotels List:"
      respond_http(error: nil, message: message, hotel_list: paginated)
    end

    # SHOW the hotel details
    # get '/hotels/show_hotel'
    # @!method show(id)
    # @param id [Number] `id` for the hotel as a Json request
    # @return [Response] the Json response of hotel details with ok status
    # @note action is behaves irrespective to the user role
    def show
      hotel = Hotel.find(params[:id])
      message = "The hotel details:"
      respond_http(error: nil, message: message, hotel_details: hotel)
    end

    # UPDATE the hotel details as an admin or owner
    # put '/hotels'
    # @!method update(request)
    # @param (see #create)
    # @return (see #create)
    # @note this method takes any params in the create action and
    #   the Owner user's `id` is updated as the `owner_id`
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
    # @!method destroy(id)
    # @param id [Number] takes the id of hotel to be deleted
    # @return [Response] success or failure message
    # @note only admin or owner of the hotel can delete a hotel
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
    # POST '/bookings_in_hotel'
    # @!method bookings(id)
    # @param id [Number] hotel `id`
    # @return [Response] of list of bookings in the hotel
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
end
