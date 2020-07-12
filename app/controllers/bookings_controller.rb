class BookingsController < ApplicationController
  def create

  	@booking = Booking.new(booking_params)
  	byebug
  	@booking.user_id = @user.id unless @user.admin?
  	@hotel = Hotel.find(params[:hotel_id])
  	@booking.rate = @hotel.rate
  	@booking.amount = @booking.rate*( params[:adults] + params[:children].to_f/2 )

  	if @booking.save!
  		render json: @booking
  	else
  		render json: {error: "Booking not created."}
	end
  end

  def show
  	case @user.role
  	when "admin"
  		@bookings = Booking.all
  	when "owner"
  		@hotel = Hotel.includes(:bookings).find_by(owner_id: @user.id)
  		@bookings = @hotel.bookings
  	else
  		@bookings = @user.bookings
  	end
  	render json: @bookings
  end

  def cancel_booking
  	@booking = Booking.find(params[:id])
  	if @user.admin? || @user == User.find(@booking.user_id)
  		@booking.booking_status = "cancelled"
  		@booking.save!
  		render json: @booking
  	else
  		render json: {message: "You are not authorized for the action"}
	end
  end
# post "checkout", to: "bookings#checkout"
# payment token and booking id as post request
  def checkout
	if params[:token]
		@booking = Booking.find(params[:id])
		@booking.payment_status = true
		@booking.booking_status = "confirmed"
		@booking.save!
		render json: @booking
	else
		render json: { message: "Payment failed."}
	end
  end

  private

	def booking_params
		params.permit(:user_id, :hotel_id, :adults, :children)
	end
end
