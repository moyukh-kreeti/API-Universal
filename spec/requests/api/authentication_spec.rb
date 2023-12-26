require 'swagger_helper'

RSpec.describe 'Authentication', type: :request do
  path '/authentication/login' do
    post 'Logs in a user' do
      tags 'Authentication'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :user, in: :body, required: true, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              email: { type: :string , default: 'moyukh00145@gmail.com'},
              password: { type: :string , default: '1234'}
            }
          }
        },
        required: ['email', 'password']
      }

      response '200', 'successful login' do
        let(:valid_user) { { email: 'test@example.com', password: 'password' } }
        run_test! do
          expect(response).to have_http_status(:ok)
          # Add any other assertions you expect in the response body or headers
        end
      end

      response '400', 'invalid credentials' do
        let(:invalid_user) { { email: 'test@example.com', password: 'wrong_password' } }
        run_test! do
          expect(response).to have_http_status(:bad_request)
          expect(JSON.parse(response.body)['msg']).to eq('Invalid Credentials')
        end
      end
    end
  end
end
