require 'swagger_helper'

RSpec.describe 'Words API', type: :request do
  path '/words/meaning' do
    get 'Retrieve the meaning of a word' do
      tags 'Words'
      produces 'application/json'
      security [bearerAuth: []]
      parameter name: :word, in: :query, type: :string, required: true, description: 'Word to get meaning'

      response '200', 'Word meaning found' do
        schema type: :array, items: { type: :string }
        let(:word) { 'example' }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data).not_to be_empty
        end
      end

      response '404', 'Word not found' do
        let(:word) { 'invalidword' }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['message']).to eq('Word not found')
        end
      end
    end
  end

  path '/words/synonym' do
    get 'Retrieve synonyms of a word' do
      tags 'Words'
      produces 'application/json'
      security [bearerAuth: []]
      parameter name: :word, in: :query, type: :string, required: true, description: 'Word to get synonyms'

      response '200', 'Synonyms found' do
        schema type: :array, items: { type: :string }
        let(:word) { 'example' }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data).not_to be_empty
        end
      end

      response '404', 'No synonyms found' do
        let(:word) { 'invalidword' }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['message']).to eq('No synonyms found')
        end
      end

      response '404', 'Word not found' do
        let(:word) { 'invalidword' }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['message']).to eq('Word not found')
        end
      end
    end
  end
end
