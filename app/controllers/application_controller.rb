class ApplicationController < ActionController::API

	include Error::ErrorHandler
  before_action :authorized

  def encode_token(payload)
    JWT.encode(payload, 's3cr3t')
  end

  def auth_header
    # { Authorization: 'Bearer <token>' }
    request.headers['Authorization']
  end

  def decoded_token
    if auth_header
      token = auth_header.split(' ')[1]
      # header: { 'Authorization': 'Bearer <token>' }
      begin
        JWT.decode(token, 's3cr3t', true, algorithm: 'HS256')
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
  private
	 	def respond_with_json(message, data, error = nil, status = 200)
	    json = {
				        status: status,
				        error: error,
				        message: message,
				        data: data
				      }
	    render json: json, status: status
	  end

end