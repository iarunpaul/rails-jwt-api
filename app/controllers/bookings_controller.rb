class BookingsController < ApplicationController
  # CREATE BOOKING post '/bookings'
  def create
  	booking = Booking.new(booking_params)
  	booking.user_id = @current_user.id unless @current_user.admin?
  	hotel = Hotel.find(params[:hotel_id])
  	booking.rate = hotel.rate
    byebug
  	booking.amount = booking.rate*( booking.adults + booking.children.to_f/2 )
    booking.save!
    message = "Booking with id #{booking.id} created"
		respond_http(status: :created, error: nil, message: message, booking_created: booking)
    # handle invalid or void attributes
  rescue ActiveRecord::RecordNotFound => e
    # raise custom error
    raise(
      ExceptionHandler::AttributeError,
      ("#{Message.invalid_credentials} #{e.message}")
    )
  rescue ActiveRecord::RecordInvalid => e
    # raise custom error
    raise(
      ExceptionHandler::AttributeError,
      ("#{Message.invalid_credentials} #{e.message}")
    )

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
  	respond_http(error: nil, message: message, booking_list: bookings)
  end

  # SHOW booking
  # post '/show_booking'
  def show
  	booking = Booking.find(params[:id])
    message = "The booking with id #{booking.id} is:"
  	respond_http(error: nil, message: message, booking_details: booking)
  end

  # UPDATE booking is only allowed to an admin user or an owner
  # put '/bookings'
  def update
  	booking = Booking.find(params[:id])
    hotel_owner = Hotel.find(booking.hotel_id).owner_id
  	if @current_user.admin? || @current_user.id == hotel_owner
		booking.update!(booking_params)
    message = "Booking updated."
		respond_http(error: nil, message: message, updated_booking: booking)
  	else
      message = "You are not permitted to edit the booking."
  		respond_http(status: 403, error: :forbidden_error, message: message, booking_details: booking)
  	end
  end

  def cancel_booking
  	booking = Booking.find(params[:id])
  	if @current_user.admin? || @current_user.id == booking.user_id
  		booking.cancelled!
  		booking.save!
      message = "Booking cancelled!"
  		respond_http(error: nil, message: message, cancelled_booking: booking)
  	else
      message = "You are not authorized for the action"
  		respond_http(status: 403, error: :forbidden_error, message: message, booking_details: booking)
    end
  end
  # CHECKOUT PAYMENT UPDATE
	# payment token IS VERIFIED and UPDATED against booking
	# post "/checkout"
  def checkout
		if params[:token]
			if booking = Booking.find(params[:id])
				booking.payment_status = true
				booking.confirmed!
				booking.save!
        message = "Payment successful!"
				respond_http(error: nil, message: message, paid_booking: booking)
			else
        message = "Booking with id #{params[:id]} not found."
	      respond_http(status: 404, error: :not_found_error, message: message)
	    end
		else
      message = "Payment failed."
			respond_http(status: 422, error: :unprocessable_error, message: message, booking_details: booking)
		end
  end

 	private
		def booking_params
			params.permit(:user_id, :hotel_id, :adults, :children)
		end
end
