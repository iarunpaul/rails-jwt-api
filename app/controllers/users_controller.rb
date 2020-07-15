class UsersController < ApplicationController
  before_action :authorized, except: [:login, :create]

  # Handles post request '/users' to create users.
  # Any user can register as customer or owner
  # Only an admin can register another admin and any other users
  # @!method create(username, password, email, role)
  # Creates a user account for a +username+
  # @param username [String] is required as unique attribute from request
  # @param password [String] is required with length constraints
  # @param email [String] is optional
  # @param role [Enum] is optional and default value is "customer"
  # @return [Json] as an api response
  def create
  	logged_user = logged_in_user
  	if logged_user && logged_user.admin?
  		@user = User.create!(user_params)
  		if @user.valid?
  			token = encode_token({user_id: @user.id})
	      message = "User created successfully"
	      data = { user: @user, token:token }
	      respond_with_json(message, data)
  		else
  			message = "Void/Invalid attributes"
  			error = "attribute_error"
	      respond_with_json(message, data = nil, error, status = 403)
  		end
    else
    	@user = User.new(user_params)
	    if @user.valid? && !@user.admin?
	    	@user.save!
	      token = encode_token({user_id: @user.id})
	      message = "User created successfully"
	      data = { user: @user, token:token }
	      respond_with_json(message, data)
	    else
	      message = "Void/Invalid/Unpermitted attributes"
  			error = "attribute_error"
	      respond_with_json(message, data = nil, error, status = 403)
	    end
    end
  end

  # Handles a post request '/login'
  # @!method login(username, password)
  # @param username [String] is required  from request
  # @param password [String] is required as matched to +username+
  # @return [Json] as an api response to the respective +username+
  # for authorization
  def login
    @user = User.find_by(username: params[:username])

    if @user && @user.authenticate(params[:password])
      token = encode_token({user_id: @user.id})
      message = "User logged in successfully"
      data = { user: @user, token:token }
      respond_with_json(message, data)
    else
      message = "Invalid username or password"
			error = "attribute_mismatch"
      respond_with_json(message, data = nil, error, status = 401)
    end
  end

  # Handle get request at '/current_user'
  # Gives current user if token exists
  # @return [Json] as an api response if bearer token is valid
  # @return [Json] with error details if no bearer token.
  # for authorization
  def current_user
    message = "Your details"
    data = { user: @current_user }
    respond_with_json(message, data)
  end
  # Updates the user account by PUT method at '/users'
  # @!method update(username, password, email, role)
  # user can update any account attributes but an admin only can update
  # the role of users as +admin+
  # @param username [String] can be updated if unique
  # @param password [String] can be updated with length constraints
  # @param email [String] can be updated
  # @param role [Enum] can be updated but "admin" role can
  #   only be updated if the user is admin
  # @return [Json] as an api response
  # @note +password+ validation is updated at the User model for not asking
  #   +password+ attribute on updation
  def update
  	if @current_user && @current_user.admin?
  		@user = User.find_by_username(params[:username])
  		# params.delete(:password) if params[:password].blank?
  		if @user.update!(user_params)
  			message = "User with id : #{@user.id} is updated."
  			respond_with_json(message, data = @user)
			else
				message = "Invalid Attribute error, not updated"
				error = "attribute_error"
				respond_with_json(message, data = nil, error, status = 401)
			end
  	else
    	@user = User.find(@current_user.id)
    	# params.delete(:password) if params[:password].blank?
	    if params[:role] != "admin"
	    	@user.update!(user_params)
	    	message = "Your record got updated."
  			respond_with_json(message, data = @user)
    	else
	      message = "Invalid/Unpermitted attribute error, not updated"
				error = "permission_attribute_error"
				respond_with_json(message, data = nil, error, status = 403)
      end
  	end
  end
  # Deletes the user by POST method at '/delete_user'
  # @!method destroy(username)
  # @param username [String] admin takes
  #   username optionally  as request parameter
  #   and deletes the user with id.
  #   For other users their account gets deleted
  # @return [Json] success delete message of account as api response
  def destroy
  	if @current_user && @current_user.admin?
  		@user = User.find_by_username(params[:username])
  		@user.delete
  		message = "User #{params[:username]} is deleted."
  		respond_with_json(message, data = nil )
  	else
  		@current_user.delete
  		message = "You have successfully deleted your account."
  		respond_with_json(message, data = nil )
  	end
  end

 private

  def user_params
  	params.permit( :username, :password, :email, :role )
  end

end