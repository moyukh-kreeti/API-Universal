require 'swagger_helper'

RSpec.describe '/users/{user_id}/posts', type: :request do
  path '/users/{user_id}/posts' do
    let(:user) { create(:user) } # Assuming you have a User factory
    let(:valid_token) { 'valid_token_value' } # Replace this with an actual valid token value

    before do
      # Define a method to set the Authorization header
      def set_auth_header(token)
        {
          'Authorization': "Bearer #{token}"
        }
      end
    end

    get 'Retrieves all posts for a user' do
      tags 'Posts'
      produces 'application/json'
      security [bearerAuth: []]
      parameter name: :user_id, in: :path, type: :integer

      response '200', 'posts found' do
        let(:user_id) { user.id }
        run_test!
      end

      response '404', 'user not found' do
        let(:user_id) { 'invalid' }
        run_test!
      end
    end

    post 'Creates a post for a user' do
      tags 'Posts'
      consumes 'application/json'
      produces 'application/json'
      security [bearerAuth: []]
      parameter name: :user_id, in: :path, type: :integer
      parameter name: :post, in: :body, schema: {
        type: :object,
        properties: {
          post: {
            type: :object,
            properties: {
              title: { type: :string },
              content: { type: :string }
            }
          }
        },
        required: %w[title content]
      }

      response '201', 'post created' do
        let(:user_id) { user.id }
        let(:post) { { title: 'New Post', content: 'Post content' } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:user_id) { user.id }
        let(:post) { {} }
        run_test!
      end
    end
  end

  path '/users/{user_id}/posts/{id}' do
    let(:user) { create(:user) }
    let(:post) { create(:post, user: user) } # Assuming you have a Post factory

    get 'Retrieves a post for a user' do
      tags 'Posts'
      produces 'application/json'
      security [bearerAuth: []]
      parameter name: :user_id, in: :path, type: :integer
      parameter name: :id, in: :path, type: :integer

      response '200', 'post found' do
        let(:user_id) { user.id }
        let(:id) { post.id }
        run_test!
      end

      response '404', 'post not found' do
        let(:user_id) { user.id }
        let(:id) { 'invalid' }
        run_test!
      end
    end

    put 'Updates a post for a user' do
      tags 'Posts'
      consumes 'application/json'
      produces 'application/json'
      security [bearerAuth: []]
      parameter name: :user_id, in: :path, type: :integer
      parameter name: :id, in: :path, type: :integer
      parameter name: :post, in: :body, schema: {
        type: :object,
        properties: {
          post: {
            type: :object,
            properties: {
              title: { type: :string },
              content: { type: :string }
            }
          }
        },
        required: %w[title content]
      }

      response '200', 'post updated' do
        let(:user_id) { user.id }
        let(:id) { post.id }
        let(:post) { { title: 'Updated Post' } }
        run_test!
      end

      response '404', 'post not found' do
        let(:user_id) { user.id }
        let(:id) { 'invalid' }
        let(:post) { { title: 'Updated Post' } }
        run_test!
      end
    end

    delete 'Deletes a post for a user' do
      tags 'Posts'
      produces 'application/json'
      security [bearerAuth: []]
      parameter name: :user_id, in: :path, type: :integer
      parameter name: :id, in: :path, type: :integer

      response '204', 'post deleted' do
        let(:user_id) { user.id }
        let(:id) { post.id }
        run_test!
      end

      response '404', 'post not found' do
        let(:user_id) { user.id }
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end

  path '/users/{user_id}/posts/create_csv' do
    let(:user) { create(:user) }
    let(:valid_token) { 'valid_token_value' } # Replace this with an actual valid token value

    before do
      # Define a method to set the Authorization header
      def set_auth_header(token)
        {
          'Authorization': "Bearer #{token}"
        }
      end
    end

    get 'Generates CSV for all posts of a user' do
      tags 'Posts'
      produces 'text/csv'
      security [bearerAuth: []]
      parameter name: :user_id, in: :path, type: :integer

      response '200', 'CSV generated' do
        let(:user_id) { user.id }
        run_test!
      end

      response '404', 'user not found' do
        let(:user_id) { 'invalid' }
        run_test!
      end
    end
  end
end
