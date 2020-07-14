class HotelsController < ApplicationController

  # CREATE hotel as owner or admin
  # post '/hotels'
   def create
    if @current_user.admin?
      @hotel = Hotel.create(hotel_params)
      render json: @hotel, status: 200
    elsif @current_user.owner?
      @hotel = Hotel.new(hotel_params)
      @hotel.owner_id = @current_user.id
      @hotel.save!
      render json: @hotel, status: 200
    else
      render json: {message: "You are not authorized to create a Hotel."}, status: 403
    end
  end

  # INDEX all the hotels for all users
  def index
    @hotels = Hotel.all
    render json: @hotels, status: 200
  end

  # SHOW the hotels with the id
  def show
    @hotel = Hotel.find(params[:id])
    render json: @hotel, status: 200
  end

  # UPDATE the hotel details as an admin or owner
  # put '/hotels'
  def update
    @hotel = Hotel.find(params[:id])
    if @current_user.admin? || @current_user.owner?
      @hotel = Hotel.update!(hotel_params)
      if @current_user.owner?
        @hotel.owner_id = @current_user.id
        @hotel.save!
      end
      render json: @hotel, status: 200
    else
      render json: {message: "You are not authorized to create a Hotel."}, status: 403
    end
  end
  # DELETE a hotel if an admin or the user is the owner of the hotel
  # post '/delete_hotel'
  def destroy
    @hotel = Hotel.find(params[:id])
    if @current_user.admin? || @current_user.id == @hotel.owner_id
      @hotel.delete
      render json: {message: "You have successfully deleted the Hotel records."}, status: 200
    else
      render json: {error: "You are not authorized to delete a Hotel reccord."}, status: 403
    end
  end

  def bookings
    @bookings = Hotel.find(params[:id]).bookings
    render json: @bookings
  end

  private
    def hotel_params
      params.permit(:name, :rating, :description, :rate)
    end
end
