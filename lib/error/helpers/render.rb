module Error::Helpers
  class Render
    def self.json(_error, _status, _message, _data)
      {
        status: _status,
        error: _error,
        message: _message,
        data: _data
      }.as_json
    end
  end
end