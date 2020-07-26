require 'rails_helper'

RSpec.describe 'Bookings API' do
  # Initialize the test data
  let!(:user) { create(:user) }
  let!(:hotel) { create(:hotel, owner_id: user.id) }
  let!(:bookings) { create_list(:booking, 20, hotel_id: hotel.id, user_id: user.id) }
  let(:hotel_id) { hotel.id }
  let(:user_id) { user.id }
  let(:id) { bookings.first.id }
  let(:headers) { valid_headers }

  # Test suite for GET /bookings/list
  describe 'BOOKINGS INDEX @ GET /bookings' do
    before { get "/bookings/list", params: {}, headers: headers }

    context 'when user is admin' do
      it 'expects the user to be admin' do
        expect(user.role).to eq('admin')
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns all hotel bookings' do
        expect(json['data']['booking_list'].size).to eq(20)
      end
    end
    context 'when user is owner' do
      let!(:user) { create(:user, role: 'owner') }
      let(:headers) { valid_headers }
      let!(:hotel) { create(:hotel, owner_id: user.id) }
      let!(:customer) { create(:user, role: 'customer') }
      let!(:bookings) { create_list(:booking, 10, hotel_id: hotel.id, user_id: customer.id) }

      before { get "/bookings/list", params: {}, headers: headers }
      it 'expects the user to be owner' do
        expect(user.role).to eq('owner')
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns all bookings in the hotel' do
        expect(json['data']['booking_list'][0].size).to eq(10)
      end
    end

    context 'when customer checks out for his bookings' do
      let!(:user) { create(:user, role: 'customer') }
      let(:headers) { valid_headers }
      let!(:owner) { create(:user, role: 'owner') }
      let!(:hotel) { create(:hotel, owner_id: owner.id) }
      let!(:bookings) { create_list(:booking, 5, hotel_id: hotel.id, user_id: user.id) }
      before { get "/bookings/list", params: {}, headers: headers }
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns a success message' do
        expect(json['data']['message']).to match(/The relevant bookings for you:/)
      end
      it 'returns a the details of the booking' do
        expect(json['data']['booking_list'].size).to eq(5)
      end
    end

  end

  # Test suite for GET /hotels/:hotel_id/bookings/:id
  describe 'SHOW BOOKING POST /show_booking' do
    before { post "/show_booking", params: { id: id }.to_json, headers: headers }

    context 'when hotel booking exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
      it 'returns a success message' do
        expect(json['data']['message']).to match(/The booking with id #{id} is:/)
      end

      it 'returns the booking' do
        expect(json['data']['booking_details']['id']).to eq(id)
      end
    end

    context 'when hotel booking does not exist' do
      let(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Booking/)
      end
    end
  end

  # Test suite for PUT /hotels/:hotel_id/bookings
  describe 'POST /bookings' do
    let!(:owner) { create(:user, role: 'owner') }
    let!(:customer) { create(:user, role: 'customer') }
    let!(:hotel) { create(:hotel, owner_id: owner.id) }
    let(:valid_attributes) { attributes_for(:booking, user_id: customer.id, hotel_id: hotel.id).to_json }

    context 'when admin submits request with valid attributes' do
      before { post "/bookings", params: valid_attributes, headers: headers }

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
      it 'returns a success message' do
        expect(json['data']['message']).to match(/created/)
      end
    end

    context 'when an invalid request' do
      before { post "/bookings", params: {}, headers: headers }

      it 'returns status code 404' do
        expect(response).to have_http_status(422)
      end

      it 'returns a failure message' do
        expect(json['message']).to match(/Invalid credentials/)
      end
    end
  end


  # # Test suite for PUT /hotels/:hotel_id/bookings/:id
  # describe 'PUT /hotels/:hotel_id/bookings/:id' do
  #   let(:valid_attributes) { {  payment_status: true }.to_json }

  #   before { put "/hotels/#{hotel_id}/bookings/#{id}", params: valid_attributes, headers: headers }

  #   context 'when booking exists' do
  #     it 'returns status code 204' do
  #       expect(response).to have_http_status(204)
  #     end

  #     it 'updates the booking' do
  #       updated_booking = Booking.find(id)
  #       expect(updated_booking.payment_status).to match(true)
  #     end
  #   end

  #   context 'when the booking does not exist' do
  #     let(:id) { 0 }

  #     it 'returns status code 404' do
  #       expect(response).to have_http_status(404)
  #     end

  #     it 'returns a not found message' do
  #       expect(response.body).to match(/Couldn't find Booking/)
  #     end
  #   end
  # end

  # # Test suite for DELETE /hotels/:id
  # describe 'DELETE /hotels/:id' do
  #   before { delete "/hotels/#{hotel_id}/bookings/#{id}", params: {}, headers: headers }

  #   it 'returns status code 204' do
  #     expect(response).to have_http_status(204)
  #   end
  # end
end