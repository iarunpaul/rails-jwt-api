require "rails_helper"

RSpec.describe "Hotel management", :type => :request do

  # Test suite for POST /hotels
  describe 'POST /hotels' do
    let(:user) { create(:user) }
    let(:headers) { valid_headers }
    let(:hotel_attributes) do
        attributes_for(:hotel)
      end
    context 'when admin/owner creates hotel with valid attributes' do
      before { post '/hotels', params: hotel_attributes.to_json, headers: valid_headers }

      it 'expects an admin user' do
        expect(user.role).to eq('admin')
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
      it 'returns success message' do
        expect(json['data']['message']).to match(/You have created the hotel records successfully/)
      end
    end

    context 'when customer creates hotel with valid attributes' do
      let(:user) { create(:user, role: "customer") }
    let(:headers) { {'Authorization' => token_generator(user.id), 'api-key' => 'api-123', "Content-Type" => "application/json"} }
      before { post '/hotels', params: hotel_attributes.to_json, headers: headers }

      it 'expects an customer user' do
        expect(user.role).to eq('customer')
      end

      it 'returns status code 403' do
        expect(response).to have_http_status(403)
      end
      it 'returns unauthorized message' do
        expect(json['data']['message']).to match(/You are not authorized to create a Hotel./)
      end
    end

    context 'when the request is invalid' do
      before { post '/hotels', params: { name: 'Foobar' }.to_json, headers: valid_headers }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match(/Validation failed: Rate can't be blank, Rating can't be blank, Owner can't be blank/)
      end
    end
  end

    # Test suite for GET /hotels/index
  describe 'GET /hotels INDEX' do
    let(:user) { create(:user, role: 'customer') }
    let(:headers) { valid_headers }
    context 'when user requests the list of hotels' do
      before { get '/hotels/index', params: {}, headers: valid_headers }

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
      it 'returns list of hotels' do
        expect(json['data']['message']).to match(/Hotels List:/)
      end
    end
  end

  describe 'POST /hotels SHOW' do
    let(:user) { create(:user, role: 'customer') }
    let(:headers) { valid_headers }
    let(:hotel) { create(:hotel, name: "Test Hotel") }
    context 'when user requests the details of the hotel' do
      before { post '/show_hotel', params: { id: hotel.id }.to_json, headers: valid_headers }

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
      it 'returns the deatils of hotel' do
        expect(json['data']['hotel_details']['name']).to match(/Test Hotel/)
      end
    end
     context 'when user requests the details of the hotel that doesn\'t exists' do
      before { post '/show_hotel', params: { id: 5 }.to_json, headers: valid_headers }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
      it 'returns the deatils of hotel' do
        expect(json['message']).to match(/Couldn't find Hotel with 'id'=5/)
      end
    end
  end


  describe 'POST /delete_hotel DELETE HOTEL' do
    let(:user) { create(:user, role: 'admin') }
    let(:headers) { valid_headers }
    let(:hotel) { create(:hotel, name: "Delete Hotel") }
    context 'when admin deletes the hotel' do
      before { post '/delete_hotel', params: { id: hotel.id }.to_json, headers: valid_headers }
      it 'expects the user to be an admin' do
        expect(user.role).to be_in(["admin"])
      end
      it 'deletes and returns status code 200' do
        expect(response).to have_http_status(200)
      end
      it 'returns the name of the hotel' do
        expect(json['data']['message']).to match(/Delete Hotel/)
      end
    end
    context 'when the hotel\'s owner updates the details of the hotel' do
      let(:user) { create(:user, role: 'owner') }
      let(:headers) { valid_headers }
      let(:hotel) { create(:hotel, name: "Delete My Hotel", owner_id: user.id) }
      before { post '/delete_hotel', params: { id: hotel.id }.to_json, headers: valid_headers }
      it 'expects the user to be the owner of the hotel' do
        expect(user.id).to eq(hotel.owner_id)
      end
      it 'deletes and returns status code 200' do
        expect(response).to have_http_status(200)
      end
      it 'returns the name of the deleted hotel' do
        expect(json['data']['message']).to match(/Delete My Hotel/)
      end
    end
     context 'when user is not the owner of the hotel' do
      let(:user) { create(:user, role: 'owner') }
      let(:headers) { valid_headers }
      before { post '/delete_hotel', params: { id: hotel.id }.to_json, headers: valid_headers }
      it 'expects the user not to be the owner of the hotel' do
        expect(user.id).not_to eq(hotel.owner_id)
      end
      it 'returns status code 403' do
        expect(response).to have_http_status(403)
      end
      it 'returns the forbidden message' do
        expect(json['data']['message']).to match(/You are not authorized to delete this Hotel./)
      end
    end
  end
  describe 'PUT /hotels UPDATE' do
    let(:user) { create(:user, role: 'admin') }
    let(:headers) { valid_headers }
    let(:hotel) { create(:hotel, name: "Test Hotel") }
    context 'when admin updates the details of the hotel' do
      before { put '/hotels', params: { id: hotel.id, name: "Hotel Name Changed" }.to_json, headers: valid_headers }
      it 'expects the user to be an admin' do
        expect(user.role).to be_in(["admin"])
      end
      it 'updates and returns status code 200' do
        expect(response).to have_http_status(200)
      end
      it 'returns the details of hotel' do
        expect(json['data']['updated_hotel']['name']).to match(/Hotel Name Changed/)
      end
    end
    context 'when the hotel\'s owner updates the details of the hotel' do
      let(:user) { create(:user, role: 'owner') }
      let(:headers) { valid_headers }
      let(:hotel) { create(:hotel, name: "Test Hotel", owner_id: user.id) }
      before { put '/hotels', params: { id: hotel.id, name: "Hotel Name Changed" }.to_json, headers: valid_headers }
      it 'expects the user to be the owner of the hotel' do
        expect(user.id).to eq(hotel.owner_id)
      end
      it 'updates and returns status code 200' do
        expect(response).to have_http_status(200)
      end
      it 'returns the details of hotel' do
        expect(json['data']['updated_hotel']['name']).to match(/Hotel Name Changed/)
      end
    end
     context 'when user is not the owner of the hotel' do
      let(:user) { create(:user, role: 'owner') }
      let(:headers) { valid_headers }
      before { put '/hotels', params: { id: hotel.id, name: "Hotel Name Changed" }.to_json, headers: valid_headers }
      it 'expects the user not to be the owner of the hotel' do
        expect(user.id).not_to eq(hotel.owner_id)
      end
      it 'returns status code 403' do
        expect(response).to have_http_status(403)
      end
      it 'returns the details of hotel' do
        expect(json['data']['message']).to match(/You are not authorized to edit this Hotel./)
      end
    end

    describe 'POST /bookings_in_hotel BOOKINGS INDEX' do
      let(:user) { create(:user, role: 'customer') }
      let(:headers) { valid_headers }
      let(:hotel) { create(:hotel) }
      let!(:bookings) { create_list(:booking, 10, hotel_id: hotel.id, user_id: user.id) }
      context 'when user requests the list of bookings in a hotel' do
        before { post '/bookings_in_hotel', params: { id: hotel.id }.to_json, headers: valid_headers }

        it 'returns status code 200' do
          expect(response).to have_http_status(200)
        end
        it 'returns success message' do
          expect(json['data']['message']).to match(/The list of bookings for the Hotel is:/)
        end
        it 'returns the list of bookings in the hotel' do
          expect(json['data']['hotel_bookings'].size).to eq 10
        end
      end
    end
  end
end