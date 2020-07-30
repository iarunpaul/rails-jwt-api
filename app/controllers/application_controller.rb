class ApplicationController < ActionController::API

	include Response
  include ExceptionHandler



  # before_action :api_key_check, :authorized, :token_refresh

  # ALGORITHM = 'HS256'

  # def encode_token(payload)
  #   JWT.encode(payload.merge(exp: 15.minutes.from_now.to_i), ENV['jwt_crypt_key'], ALGORITHM)
  # end

  # def token_refresh
  # 	response.headers['auth_token'] = encode_token({ user_id: @current_user.id }) if logged_in?
  # end

  # def auth_header
  #   # { Authorization: 'Bearer <token>' }
  #   request.env['HTTP_AUTHORIZATION']
  # end

  # def decoded_token
  #   if auth_header
  #     token = auth_header.split(' ')[1]
  #     # header: { 'Authorization': 'Bearer <token>' }
  #     begin
  #       JWT.decode(token, ENV['jwt_crypt_key'], true, algorithm: ALGORITHM)
  #     rescue JWT::DecodeError
  #       nil
  #     end
  #   end
  # end

  # def logged_in_user
  #   if decoded_token
  #     user_id = decoded_token[0]['user_id']
  #     @current_user = User.find_by(id: user_id)
  #   end
  # end

  # def logged_in?
  #   !!logged_in_user
  # end

  # def authorized
  #   render json: { message: 'You are logged out. Log In please!' }, status: :unauthorized unless logged_in?
  # end

  # handles response to render in jason format
  # takes status and data in key value pairs and renders
  # @param status [{Key=>Value}] default set to 200
  # @param _json_hash [Hash{Key=>Value}] all the data send in key value pairs goes here
  # @return [Resposne]
  def respond_http(status: 200, **_json_hash)
  	render json: {status: status, data: _json_hash }, status: status
  end

  # private
  # 	def api_key_check
  # 		render json: {
  # 				message: "Sorry!! Key is missing to access the app" },
  # 				status: 401 unless request.headers['api-key'] == ENV['API_KEY']
  # 	end
  #
  # called before every action on controllers
  before_action :authorize_with_key, :authorize_request
  # reads the current authorized user
  # @return [Hash{Key=>Value}]
  attr_reader :current_user

  private

  # @!method authorize_request
  # Check for valid request token and return user
  # @!scope class
  # @!visibility private
  # @return [Hash{Key=>Value}] the authorized signed in user
  def authorize_request
    @current_user = (AuthorizeApiRequest.new(request.headers).call)[:user]
  end
  # @!method authorize_with_key
  # Check for valid api key and return response
  # @!scope class
  # @!visibility private
  # @return [Error, nil] return error if key is missing/invalid. Can be nil if key matches
  def authorize_with_key
    raise(ExceptionHandler::MissingApiKey, Message.missing_key) if request.headers['api-key'] != ENV['API_KEY']
  end
end
