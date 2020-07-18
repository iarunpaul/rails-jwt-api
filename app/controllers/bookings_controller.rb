class BookingsController < ApplicationController
  # CREATE BOOKING post '/bookings'
  def create
  	booking = Booking.new(booking_params)
  	booking.user_id = @current_user.id unless @current_user.admin?
  	hotel = Hotel.find(params[:hotel_id])
  	booking.rate = hotel.rate
  	booking.amount = booking.rate*( booking.adults + booking.children.to_f/2 )
  	if booking.valid?
      booking.save!
      message = "Booking with id #{booking.id} created"
  		respond_http(200, message, booking)
  	else
      message = "Booking not valid."
  		respond_http(422, message, nil)
		end
  end

  # LIST OF bookings relevent to roles
  # get '/bookings/list'
  def index
  	if @current_user.admin?
  		bookings = Booking.all
  	elsif @current_user.owner?
  		hotels = Hotel.includes(:bookings).where(owner_id: @current_user.id)# eager loading
  		bookings = []
  		hotels.each do |hotel|
  			bookings.push(hotel.bookings)
  		end
  	else
  		bookings = @current_user.bookings
  	end
    message = "The relevant bookings for you:"
  	respond_http(200, message, bookings)
  end

  # SHOW booking
  # post '/show_booking'
  def show
  	booking = Booking.find(params[:id])
    message = "The booking with id #{booking.id} is:"
  	respond_http(200, message, booking)
  end

  # UPDATE booking is only allowed to an admin user or an owner
  # put '/bookings'
  def update
  	booking = Booking.find(params[:id])
    hotel_owner = Hotel.find(booking.hotel_id).owner_id
  	if @current_user.admin? || @current_user.id == hotel_owner
		booking.update!(booking_params)
    message = "Booking updated."
		respond_http(200, message, booking)
  	else
  		render json: {message: "You are not permitted to edit the booking."}, status: 403
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
