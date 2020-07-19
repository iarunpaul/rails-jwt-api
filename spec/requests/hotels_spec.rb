require "rails_helper"

RSpec.describe "Hotel management", :type => :request do

  it "creates a Hotel" do

    headers = { "api-key" => "api-123" }
    post "/hotels", :params => {:name => "Learn Elm", :rate => 1, :rating => 1, :owner_id => 1}, :headers => headers

    expect(response.content_type).to eq("application/json; charset=utf-8")
    expect(response).to have_http_status(200)
    # expect(json['name']).to eq('My Hotel')
  end

end


  # # Test suite for POST /todos
  # describe 'POST /hotels' do
  #   # valid payload
  #   let(:valid_attributes) { { name: 'Learn Elm', owner_id: '1' } }

  #   context 'when the request is valid' do
  #     before { post '/hotels', params: valid_attributes }

  #     it 'creates a hotel' do
  #       expect(json['name']).to eq('Learn Elm')
  #     end

  #     it 'returns status code 200' do
  #       expect(response).to have_http_status(200)
  #     end
  #   end

  #   context 'when the request is invalid' do
  #     before { post '/hotels', params: { name: 'Foobar' } }

  #     it 'returns status code 422' do
  #       expect(response).to have_http_status(406)
  #     end

  #     it 'returns a validation failure message' do
  #       expect(response.body)
  #         .to match(/Validation failed: Created by can't be blank/)
  #     end
  #   end
  # end

# end