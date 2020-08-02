class V2::HotelsController < ApplicationController
	def index
    	json_response({ message: 'Hello I\'m from V2' })
  	end
end
