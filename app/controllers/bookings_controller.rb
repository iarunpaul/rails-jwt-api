class BookingsController < ApplicationController
  # CREATE BOOKING post '/bookings'
  def create
  	@booking = Booking.new(booking_params)
  	@booking.user_id = @current_user.id unless @current_user.admin?
  	@hotel = Hotel.find(params[:hotel_id])
  	@booking.rate = @hotel.rate
  	@booking.amount = @booking.rate*( @booking.adults + @booking.children.to_f/2 )
  	if @booking.save!
  		render json: @booking
  	else
  		render json: {message: "Booking not created."}, status: 404
		end
  end

  # LIST OF bookings relevent to roles
  # get '/bookings/list'
  def index
  	if @current_user.admin?
  		@bookings = Booking.all
  	elsif @current_user.owner?
  		@hotels = Hotel.includes(:bookings).where(owner_id: @current_user.id)# eager loading
  		@bookings = []
  		@hotels.each do |hotel|
  			@bookings.push(hotel.bookings)
  		end
  	else
  		@bookings = @current_user.bookings
  	end
  	render json: @bookings, status: 200
  end

  # SHOW booking
  # post '/show_booking'
  def show
  	booking = Booking.find(params[:id])
  	render json: booking, status: 200
  end

  # UPDATE booking is only allowed to an admin user or an owner
  # put '/bookings'
  def update
  	booking = Booking.find(params[:id])
  	if @current_user.admin? || @current_user.id == Hotel.find_by(booking.hotel_id).owner_id

		booking.update!(booking_params)
		render json: booking, status: 200
  	else
  		render json: {message: "You are not permitted to edit any booking."}, status: 403
  	end
  end

  def cancel_booking
  	@booking = Booking.find(params[:id])
  	if @current_user.admin? || @current_user.id == @booking.user_id
  		@booking.booking_status = "cancelled"
  		@booking.save!
  		render json: @booking, status: 200
  	else
  		render json: {message: "You are not authorized for the action"}, status: 403
	end
  end
  # CHECKOUT PAYMENT UPDATE
	# payment token IS VERIFIED and UPDATED against booking
	# post "/checkout"
  def checkout
		if params[:token]
			if @booking = Booking.find(params[:id])
				@booking.payment_status = true
				@booking.booking_status = "confirmed"
				@booking.save!
				render json: @booking, status: 200
			else
	      render json: { error: "Booking with id #{params[:id]} not found." }, status: :not_found
	    end
		else
			render json: { message: "Payment failed."}
		end
  end

 	private
		def booking_params
			params.permit(:user_id, :hotel_id, :adults, :children)
		end
end
