# @author arun paul
class BookingsController < ApplicationController
  # CREATE BOOKING @ post '/bookings'
  # @!method create(request)
  # @param request [Request] with valid attributes of user_id, hotel_id, and +adults+
  #   and +children+ as optional
  # @return [Response] with the status and data, rescued with
  #   custom error messages if error occured
  # @raise [ActiveRecord::RecordNotFound] raises and rescues the attribute
  #   error with custom error class AttributeError
  # @raise [ActiveRecord::RecordInvalid] raises and rescues the attribute
  #   error with custom error class, AttributeError
  def create
  	booking = Booking.new(booking_params)
  	booking.user_id = @current_user.id unless @current_user.admin?
  	hotel = Hotel.find(params[:hotel_id])
  	booking.rate = hotel.rate
  	booking.amount = booking.rate*( booking.adults + booking.children.to_f/2 )
    booking.save!
    message = "Booking with id #{booking.id} created"
		respond_http(status: :created, error: nil, message: message, booking_created: booking)
  rescue ActiveRecord::RecordNotFound => e
    raise(
      ExceptionHandler::AttributeError,
      ("#{Message.invalid_credentials} #{e.message}")
    )
  rescue ActiveRecord::RecordInvalid => e
    raise(
      ExceptionHandler::AttributeError,
      ("#{Message.invalid_credentials} #{e.message}")
    )

  end

  # LIST OF bookings relevant to roles
  # get '/bookings/list'
  # @!method index(request)
  # @param request [Request] with valid headers
  # @return [Array[Hash{Key=>Values}]]
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

  # SHOW booking @
  # post '/show_booking'
  # @!method show(request)
  # @param request [Request] with booking `id` with valid header
  # @return (see #create)
  def show
  	booking = Booking.find(params[:id])
    message = "The booking with id #{booking.id} is:"
  	respond_http(error: nil, message: message, booking_details: booking)
  end

  # UPDATE booking is only allowed to an admin user or an owner @
  # put '/bookings'
  # @!method update(request)
  # @param request [Request] with valid attributes of id(required)
  #   user_id, hotel_id, adults or children, payment_status, booking_status
  # @return [Response] with updated booking details
  # @raise [RoleError] raises custom role error if
  #   user +role+ doesn't permit action
  # @raise [RecordInvalid] raises custom role error if
  #   booking+id+ doesn't exists
  def update
  	booking = Booking.find(params[:id])
    hotel_owner = Hotel.find(booking.hotel_id).owner_id
  	if @current_user.admin? || @current_user.id == hotel_owner
  		booking.update!(booking_params)
      message = "Booking updated."
  		respond_http(error: nil, message: message, updated_booking: booking)
  	else
      raise ExceptionHandler::RoleError, Message.role_error
    end
  end
  # CANCEL booking is only allowed to an admin user or user whom the booking belongs to
  # routing @ post '/cancel_booking'
  # @!method cancel_booking(id)
  # @param id [Number] with valid attributes of id(required)
  # @return [Response] with cancelled booking details
  # @raise [RecordNotFound] raises not found error if
  #   user +id+ doesn't exist
  # @raise [RecordInvalid] raises invalid error if
  #   booking+id+ is invalid
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
	# payment token IS VERIFIED and UPDATED against booking@
	# post "/checkout"
  # @!method checkout(request)
  # @param [Request] request has +token+ and booking+id+,
  #   payment+token+ needs to be valid for updating the +payment_status+ and +booking_status+ successfully
  # @return [Response] updated booking details with payment, returns status 422 if token is nil
  # @raise [RecordNotFound] raises not found error if
  #   user +id+ doesn't exist
  # @raise [RecordInvalid] raises invalid error if
  #   booking+id+ is invalid
  def checkout
    booking = Booking.find(params[:id])
		if params[:token]
			booking.payment_status = true
			booking.confirmed!
			booking.save!
      message = "Payment successful!"
			respond_http(error: nil, message: message, paid_booking: booking)
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
