require 'swagger_helper'

RSpec.describe WordsController, type: :request do
  path '/words/get_word/{word}' do
    get 'Retrieves a word definition' do
      tags 'Words'
      produces 'application/json'
      security [bearerAuth: []]
      parameter name: :word, in: :path, type: :string, description: 'Word to retrieve'

      response '200', 'word found' do
        let(:word) { 'example' }

        run_test! do |response|
          data = JSON.parse(response.body)
          # Add your expectations/assertions based on the response data
          expect(response).to be_successful
          expect(data).to include('your_expected_key')
        end
      end

      response '404', 'word not found' do
        let(:word) { 'nonexistentword' }

        run_test! do |response|
          data = JSON.parse(response.body)
          # Add your expectations/assertions based on the response data
          expect(response).to be_not_found
          expect(data).to include('error_message')
        end
      end
    end
  end
end
