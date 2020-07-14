class UsersController < ApplicationController
  before_action :authorized, except: [:login, :create]

  # REGISTER post '/users'
  # User can register self as customer or owner
  # Only an admin can register another admin and other users
  def create
  	logged_user = logged_in_user
  	if logged_user && logged_user.admin?
  		@user = User.create(user_params)
  		if @user.valid?
  			token = encode_token({user_id: @user.id})
  			render json: {user: @user, token: token}, status: 200
  		else
  			render json: {error: "Invalid attributes."}, status: 403
  		end
    else
    	@user = User.new(user_params)
	    if @user.valid? && !@user.admin?
	    	@user.save!
	      token = encode_token({user_id: @user.id})
	      render json: {user: @user, token: token}, status: 200
	    else
	      render json: {error: "Invalid/Unpermitted attributes."}, status: 403
	    end
    end
  end

  # LOGGING IN post '/login'
  def login
    @user = User.find_by(username: params[:username])

    if @user && @user.authenticate(params[:password])
      token = encode_token({user_id: @user.id})
      render json: {user: @user, token: token}
    else
      render json: {error: "Invalid username or password"}, status: 401
    end
  end

  # CURRENT USER get '/current_user'
  # Gives current user if token exists
  def current_user
  	render json: @current_user, status: 200
  end
  # UPDATE put '/users'
  # updates account attributes, and admin only can update the role of users
  def update
  	if @current_user && @current_user.admin?
  		@user = User.find_by_username(params[:username])
  		if @user.update!(user_params)
  			render json: {message: "User with id : #{params[:id]} is updated."}, status: 200
			else
				render json: {message: "Attribute error, not updated"}, status: 403
			end
  	else
    	@user = User.find(@current_user.id)
	    if params[:role] != "admin"
	    	@user.update!(user_params)
	    	render json: {user: @user, message: "Account updated."}, status: 200
    	else
	      render json: {error: "Invalid/Unpermitted attributes."}, status: 403
      end
  	end
  end
  # DELETE
  # Optionally takes id as request from admin
  # and deletes the user with id
  # for other users their account gets deleted
  def destroy
  	if @current_user && @current_user.admin?
  		@user = User.find(params[:id])
  		@user.delete
  		render json: {message: "User with id : #{params[:id]} is deleted."}, status: 200
  	else
  		@current_user.delete
  		render json: {message: "You have successfully deleted your account."}, status: 200
  	end
  end

 private

  def user_params
  	params.permit( :username, :password, :email, :role )
  end

end