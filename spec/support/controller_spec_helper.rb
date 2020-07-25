module ControllerSpecHelper
  # generate tokens from user id
  def token_generator(user_id)
    JsonWebToken.encode(user_id: user_id)
  end

  # generate expired tokens from user id
  def expired_token_generator(user_id)
    JsonWebToken.encode({ user_id: user_id }, (Time.now.to_i - 10))
  end

  # return valid headers
  def valid_headers
    {
      "Authorization" => token_generator(user.id),
      "Content-Type" => "application/json",
      "api-key" => "api-123"
    }
  end

  # return invalid headers
   def invalid_headers
    {
      "Authorization" => nil,
      "Content-Type" => "application/json",
      "api-key" => "api-123"
    }
  end

  def keyless_headers
    {
      "Authorization" => token_generator(user.id),
      "Content-Type" => "application/json",
      "api-key" => nil
    }
  end
end