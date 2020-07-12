class HotelsController < ApplicationController
   def create
    if @user.admin? || @user.owner?
      @hotel = Hotel.new(hotel_params)
      @hotel.created_by = @user.id
      @hotel.save!
      render json: @hotel
    else
      render json: {error: "You are not authorized to create a Hotel."}
    end
  end

  def show
    @hotels = Hotel.all
    render json: @hotels
  end

  def update
    @hotel = Hotel.find(params[:id])
    if @user.admin? || @user.id == @hotel.created_by || @user.id == @hotel.updated_by
      @hotel.updated_by = @user.id
      @hotel.update_attributes(hotel_params)
      render json: @hotel
    else
      render json: {error: "You are not authorized to edit a Hotel record."}
    end
  end

  def destroy
    @hotel = Hotel.find(params[:id])
    if @user.admin? || @user.id == @hotel.created_by || @user.id == @hotel.updated_by
      @hotel.delete
      render json: {message: "You have successfully deleted the Hotel records."}
    else
      render json: {error: "You are not authorized to delete a Hotel reccord."}
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
