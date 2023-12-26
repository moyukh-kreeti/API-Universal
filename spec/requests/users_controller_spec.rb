require 'rails_helper'

RSpec.describe "UsersControllers", type: :request do
  describe 'GET #index' do
    it 'returns a success response' do
      token = JwtWebToken.encode({id: 1, email: 'john@gmail.com',name: "john Doe"})
      get '/users',headers: {'Authorization' => "Bearer #{token}"}
      expect(response).to be_successful
    end
    it 'returns authorization failed' do
      get '/users'
      expect(response).to be_unauthorized
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      user_attr = { first_name: 'John', last_name: 'Doe', email: 'john.doe@example.com', password_digest: 'password'}
      user = User.find_or_create_by(user_attr)
      token = JwtWebToken.encode({id: user.id, email: user.email,name: "#{user.first_name} #{user.last_name}"})
      get "/users/#{user.id}",headers: {'Authorization' => "Bearer #{token}"}
      expect(response).to be_successful
    end

    it 'returns unauthorized response' do
      user_attr = { first_name: 'John', last_name: 'Doe', email: 'john.doe@example.com', password_digest: 'password'}
      user = User.find_or_create_by(user_attr)
      get "/users/#{user.id}"
      expect(response).to be_unauthorized
    end

    it 'valid data for valid user params' do
      user_attr = { first_name: 'John', last_name: 'Doe', email: 'john.doe@example.com', password_digest: 'password'}
      user = User.find_or_create_by(user_attr)
      token = JwtWebToken.encode({id: user.id, email: user.email,name: "#{user.first_name} #{user.last_name}"})
      get "/users/#{user.id}",headers: {'Authorization' => "Bearer #{token}"}
      expect(response).to be_successful

      json_response = JSON.parse(response.body)
      expect(json_response['id']).to eq(user.id)
      expect(json_response['email']).to eq(user.email)
      expect(json_response['first_name']).to eq(user.first_name)
      expect(json_response['last_name']).to eq(user.last_name)
    end

    it 'invalid data for invalid user params' do
      user_attr = { first_name: 'John', last_name: 'Doe', email: 'john.doe@example.com', password_digest: 'password'}
      user = User.find_or_create_by(user_attr)
      token = JwtWebToken.encode({id: user.id, email: user.email,name: "#{user.first_name} #{user.last_name}"})
      get "/users/999",headers: {'Authorization' => "Bearer #{token}"}
      expect(response).to have_http_status(404)
    end
  end

  describe 'POST #create' do
    it 'creates a new user' do
      user_params = { user: { first_name: 'Jane', last_name: 'Doe', email: 'jane.doe@example.com', password: 'password' } }

      expect {
        post '/users', params: user_params
      }.to change(User, :count).by(1)

      expect(response).to have_http_status(:ok)
      expect(json_response['token']).to be_present
      expect(json_response['user_data']['id']).to be_present
    end

    it 'returns a bad request for invalid user data' do
      invalid_params = { user: { first_name: '', last_name: '', email: '', password: '' } }

      post '/users', params: invalid_params

      expect(response).to have_http_status(:bad_request)
      expect(json_response['msg']).to eq('Some Error Occured')
    end
  end

  describe 'PUT #update' do
    it 'updates the user' do
      user = User.create!(first_name: 'Old', last_name: 'Name', email: 'old.name@example.com', password: 'password')
      new_params = { user: { first_name: 'New', last_name: 'Name' } }
      token = JwtWebToken.encode({id: user.id, email: user.email,name: "#{user.first_name} #{user.last_name}"})
      put "/users/#{user.id}", params: new_params ,headers: {'Authorization' => "Bearer #{token}"}

      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response['first_name']).to eq('New')
    end
    it 'user is unauthorized' do
      user = User.create!(first_name: 'Old', last_name: 'Name', email: 'old.name@example.com', password: 'password')
      new_params = { user: { first_name: 'New', last_name: 'Name' } }
      put "/users/#{user.id}", params: new_params 

      expect(response).to be_unauthorized
    end

    it 'invalid user' do
      user = User.create!(first_name: 'Old', last_name: 'Name', email: 'old.name@example.com', password: 'password')
      new_params = { user: { first_name: 'New', last_name: 'Name' } }
      token = JwtWebToken.encode({id: user.id, email: user.email,name: "#{user.first_name} #{user.last_name}"})
      put "/users/999", params: new_params ,headers: {'Authorization' => "Bearer #{token}"}

      expect(response).to have_http_status(404)
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the user' do
      user = User.create!(first_name: 'John', last_name: 'Doe', email: 'john.doe@example.com', password: 'password')
      token = JwtWebToken.encode({id: user.id, email: user.email,name: "#{user.first_name} #{user.last_name}"})
      expect {
        delete "/users/#{user.id}",headers: {'Authorization' => "Bearer #{token}"}
      }.to change(User, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end

    it 'unauthorized user' do
      user = User.create!(first_name: 'John', last_name: 'Doe', email: 'john.doe@example.com', password: 'password')

      expect {
        delete "/users/#{user.id}"
      }.to change(User, :count).by(0)

      expect(response).to be_unauthorized
    end

    it 'user does not exist' do
      user = User.create!(first_name: 'John', last_name: 'Doe', email: 'john.doe@example.com', password: 'password')
      token = JwtWebToken.encode({id: user.id, email: user.email,name: "#{user.first_name} #{user.last_name}"})
      expect {
        delete "/users/999",headers: {'Authorization' => "Bearer #{token}"}
      }.to change(User, :count).by(0)

      expect(response).to have_http_status(404)
    end
  end

  def json_response
    JSON.parse(response.body)
  end
end
