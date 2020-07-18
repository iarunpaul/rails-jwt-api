class ApplicationController < ActionController::API

	include Error::ErrorHandler

  before_action :api_key_check, :authorized, :token_refresh

  ALGORITHM = 'HS256'

  def encode_token(payload)
    JWT.encode(payload.merge(exp: 15.minutes.from_now.to_i), ENV['jwt_crypt_key'], ALGORITHM)
  end

  def token_refresh
  	response['auth_token'] = encode_token({ user_id: @current_user.id }) if logged_in?
  end

  def auth_header
    # { Authorization: 'Bearer <token>' }
    request.env['HTTP_AUTHORIZATION']
  end

  def decoded_token
    if auth_header
      token = auth_header.split(' ')[1]
      # header: { 'Authorization': 'Bearer <token>' }
      begin
        JWT.decode(token, ENV['jwt_crypt_key'], true, algorithm: ALGORITHM)
      rescue JWT::DecodeError
        nil
      end
    end
  end

  def logged_in_user
    if decoded_token
      user_id = decoded_token[0]['user_id']
      @current_user = User.find_by(id: user_id)
    end
  end

  def logged_in?
    !!logged_in_user
  end

  def authorized
    render json: { message: 'You are logged out. Log In please!' }, status: :unauthorized unless logged_in?
  end

  def respond_http(status, message, data)
  	# token ||= nil
  	# response.headers['auth_token'] = token
  	render json: {status: status, message: message, data: data }, status: status
  end
  private
  	def api_key_check
  		render json: {
  			message: "Sorry!! Key is missing to access the app" },
  			status: 403 unless request.headers['api-key'].to_i == 123
  	end

end