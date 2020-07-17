class UsersController < ApplicationController
  before_action :authorized, except: [:login, :create]

  # REGISTER post '/users'
  # User can register self as customer or owner
  # Only an admin can register another admin and other users
  def create

  	if logged_in? && @current_user.admin?
  		adm_rfrsh_tokn = encode_token({user_id: @current_user.id})
  		user = User.create(user_params)
  		if user.valid?
  			usr_token = encode_token({user_id: user.id})
  			message = "User with id #{user.id} created successfully"
  			data = { user: user, user_token: usr_token }
  			respond_http(200, message, data, adm_rfrsh_tokn)
  		else
  			message = "Void/Invalid attributes."
  			respond_http(403, message, nil, adm_rfrsh_tokn)
  		end
    else
    	user = User.new(user_params)
	    if user.valid? && !user.admin?
	    	user.save!
	    	usr_token = encode_token({user_id: user.id})
	    	message = "User created successfully"
	    	data = { user: user, user_token: usr_token }
	      respond_http(200, message, data, nil)
	    else
	      message = "Void/Invalid attributes."
	  		respond_http(403, message, nil, nil)
	    end
    end
  end

  # LOGGING IN post '/login'
  def login
    user = User.find_by(username: params[:username])

    if user && user.authenticate(params[:password])
      token = encode_token({user_id: user.id})
      data = {user: user, token: token}
      message = "User logged in successfully"
      respond_http(200, message, data, nil)
    else
    	message = "Invalid username or password"
      respond_http(401, message, nil, nil)
    end
  end

  # CURRENT USER get '/current_user'
  # Gives current user if token exists
  def current_user
  	message = "You are logged in as:"
  	rfrsh_tokn = encode_token({user_id: @current_user.id})
    respond_http(200, message, @current_user, rfrsh_tokn)
  end

  def show
  	if @current_user.admin?
  		adm_rfrsh_tokn = encode_token({user_id: @current_user.id})
  		user = User.find_by(username: params[:username])
  		message = "See the user details."
  		data = { user: user }
  		respond_http(200, message, data, adm_rfrsh_tokn)
  	else
  		rfrsh_tokn = encode_token({user_id: @current_user.id})
  		message = "Only admin can view user details."
  		data = nil
  		respond_http(200, message, data, rfrsh_tokn)
  	end
  end
  # UPDATE put '/users'
  # updates account attributes, and admin only can update the role of users
  def update
  	if @current_user && @current_user.admin?
  		adm_rfrsh_tokn = encode_token({user_id: @current_user.id})
  		user = User.find_by_username(params[:username])
  		if user.update!(user_params)
  			data = { user: user }
      	message = "User with id #{user.id} is updated successfully"
      	respond_http(200, message, data, adm_rfrsh_tokn)
			else
				data = { user: user }
       	message = "Attribute error, User not updated"
      	respond_http(403, message, data, adm_rfrsh_tokn)
			end
  	else
    	rfrsh_tokn = encode_token({user_id: @current_user.id})
	    if params[:role] != "admin"
	    	@current_user.update!(user_params)
	    	data = { user: @current_user }
      	message = "Your accout got updated successfully"
      	respond_http(200, message, data, rfrsh_tokn)
    	else
	      data = { user: user }
       	message = "Attribute error, User not updated"
      	respond_http(403, message, data, rfrsh_tokn)
      end
  	end
  end
  # DELETE
  # Optionally takes id as request from admin
  # and deletes the user with id
  # for other users their account gets deleted
  # post '/delete_user'
  def destroy
  	if @current_user && @current_user.admin?
  		adm_rfrsh_tokn = encode_token({user_id: @current_user.id})
  		user = User.find_by_username(params[:username])
  		user.delete
  		data = nil
      message = "User with id #{user.id} is deleted successfully"
      respond_http(200, message, data, adm_rfrsh_tokn)
  	else
  		@current_user.delete
  		message = "You have successfully deleted your account."
  		data = nil
  		respond_http(200, message, data, nil)
  	end
  end

 private

  def user_params
  	params.permit( :username, :password, :email, :role )
  end

end