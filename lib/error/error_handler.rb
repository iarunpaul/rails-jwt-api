# Refactored ErrorHandler to handle multiple errors
# Rescue StandardError acts as a Fallback mechanism to handle any exception
module Error
  module ErrorHandler
    def self.included(clazz)
      clazz.class_eval do
        rescue_from ActiveRecord::RecordNotFound do |e|
          data = 'Its raised by Active Record when'\
          ' record doesnt exists in DB'
          respond(:record_not_found, 404, e.to_s, data)
        end
        rescue_from StandardError do |e|
          data = 'Its a standard error raised by the internal server'
          respond(:standard_error, 500, e.to_s, data)
        end
        rescue_from NoMethodError do |e|
          data = 'Its normally raised when the'\
          ' username doesnt exists in DB. Please check the username is correct.'
          respond(:nil_value_error, 500, e.to_s, data)
        end
      end
    end

    private
      def respond(_error, _status, _message, _data)
        json = Helpers::Render.json(_error, _status, _message, _data)
        render json: json, status: _status
      end
  end
end