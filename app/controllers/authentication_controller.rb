# @author arun paul
class AuthenticationController < ApplicationController

	 skip_before_action :authorize_request, only: :authenticate
	# @!method authenticate(request)
	# handles an authentication request from user and
	#   returns auth token once user is authenticated
	#
	# @param request [Request] username [String] takes the username of user
	#   and password [String] takes the password set
	# @return [Response] as an `auth_token` for authorization process
	def authenticate
		auth_token =
		AuthenticateUser.new(auth_params[:username], auth_params[:password]).call
		json_response(auth_token: auth_token)
	end

	private
	# @!method auth_params(params = {})
	# The authentication params whitelisting method!
	# @!scope class
	# @!visibility private
	def auth_params
		params.permit(:username, :password)
	end
end
