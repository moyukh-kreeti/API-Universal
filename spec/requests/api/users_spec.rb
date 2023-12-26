require 'swagger_helper'

RSpec.describe '/users', type: :request do
  let(:valid_token) { 'valid_token_value' } # Replace this with an actual valid token value

  before do
    # Define a method to set the Authorization header
    def set_auth_header(token)
      {
        'Authorization': "Bearer #{token}"
      }
    end
  end
  path '/users' do
    get 'Retrieves all users' do
      tags 'Users'
      produces 'application/json'
      security [bearerAuth: []]
      response '200', 'users found' do
        run_test!
      end
    end

    post 'Creates a user' do
      tags 'Users'
      consumes 'application/json'
      produces 'application/json'
      security [bearerAuth: []]
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              first_name: { type: :string },
              last_name: { type: :string },
              email: { type: :string },
              password: { type: :string }
            }
          }
        },
        required: %w[first_name last_name email password]
      }

      response '200', 'user created' do
        let(:user) { { first_name: 'John', last_name: 'Doe', email: 'john@example.com', password: 'password' } }
        run_test!
      end

      response '400', 'invalid request' do
        let(:user) { {} }
        run_test!
      end
    end
  end

  path '/users/{id}' do
    get 'Retrieves a user' do
      tags 'Users'
      produces 'application/json'
      security [bearerAuth: []]
      parameter name: :id, in: :path, type: :integer

      response '200', 'user found' do
        let(:id) { User.create(first_name: 'John', last_name: 'Doe', email: 'john@example.com', password: 'password').id }
        run_test!
      end

      response '404', 'user not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end

    put 'Updates a user' do
      tags 'Users'
      consumes 'application/json'
      produces 'application/json'
      security [bearerAuth: []]
      parameter name: :id, in: :path, type: :integer
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              first_name: { type: :string },
              last_name: { type: :string },
              email: { type: :string },
              password: { type: :string }
            }
          }
        },
        required: %w[first_name last_name email password]
      }

      response '200', 'user updated' do
        let(:id) { User.create(first_name: 'John', last_name: 'Doe', email: 'john@example.com', password: 'password').id }
        let(:user) { { first_name: 'Jane' } }
        run_test!
      end

      response '404', 'user not found' do
        let(:id) { 'invalid' }
        let(:user) { { first_name: 'Jane' } }
        run_test!
      end
    end

    delete 'Deletes a user' do
      tags 'Users'
      produces 'application/json'
      security [bearerAuth: []]
      parameter name: :id, in: :path, type: :integer

      response '204', 'user deleted' do
        let(:id) { User.create(first_name: 'John', last_name: 'Doe', email: 'john@example.com', password: 'password').id }
        run_test!
      end

      response '404', 'user not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end
end