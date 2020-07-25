require 'rails_helper'

RSpec.describe 'Users API', type: :request do
  let(:user) { build(:user) }
  let(:headers) { valid_headers.except('Authorization') }
  let(:valid_attributes) do
    attributes_for(:user)
  end

  # User signup test suite
  describe 'POST /signup' do
    context 'when valid request' do
      before { post '/signup', params: valid_attributes.to_json, headers: headers }

      it 'creates a new user' do
        expect(response).to have_http_status(201)
      end

      it 'returns success message' do
        expect(json['message']).to match(/Account created successfully/)
      end

      it 'returns an authentication token' do
        expect(json['auth_token']).not_to be_nil
      end
    end

    context 'when invalid request' do
      before { post '/signup', params: {}, headers: headers }

      it 'does not create a new user' do
        expect(response).to have_http_status(422)
      end

      it 'returns failure message' do
        expect(json['message'])
          .to match(/Validation failed: Password can't be blank, Username can't be blank/)
      end
    end
    context 'when valid request from admin user' do
      let(:user) { create(:user) }
      let(:headers) { valid_headers }
      let(:current_user) { (AuthorizeApiRequest.new(headers).user) }
      before { post '/signup', params: {"username": "Admin", "password": "password", "email": "email@email.com", "role": "admin"}.to_json, headers: headers }

      it 'expects the current user an admin' do
        expect(current_user.role).to eq("admin")
      end
      it 'creates a new user' do
        expect(response).to have_http_status(201)
      end
      it 'creates an admin role for new user' do
        expect(user.role).to eq("admin")
      end

      it 'returns success message' do
        expect(json['message']).to match(/Account created successfully/)
      end

      it 'returns an authentication token' do
        expect(json['auth_token']).not_to be_nil
      end
    end
  end
end