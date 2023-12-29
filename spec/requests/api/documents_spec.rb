require 'swagger_helper'

RSpec.describe 'api/documents', type: :request do
  path '/documents' do
    get 'Retrieves all documents' do
      tags 'Documents'
      produces 'application/json'
      security [bearerAuth: []]

      response '200', 'documents found' do
        run_test! do
          # Your test code here for successful retrieval of documents
        end
      end
    end

    post 'Creates a document' do
      tags 'Documents'
      consumes 'multipart/form-data'
      security [bearerAuth: []]
      parameter name: :file, in: :formData, type: :file

      response '200', 'document uploaded' do
        let(:file) { fixture_file_upload('test.pdf', 'application/pdf') }
        run_test! do
          # Your test code here for successful document upload
        end
      end

      response '400', 'something went wrong' do
        let(:file) { fixture_file_upload('test.txt', 'text/plain') }
        run_test! do
          # Your test code here for failed document upload
        end
      end
    end
  end

  path '/documents/{id}' do
    get 'Retrieves a specific document' do
      tags 'Documents'
      produces 'application/pdf'
      security [bearerAuth: []]

      parameter name: :id, in: :path, type: :string, description: 'Document ID'

      response '200', 'document found' do
        let(:id) { Document.create(file: 'test.pdf', s3_object: 's3_key').id }
        run_test! do
          # Your test code here for successful retrieval of a specific document
        end
      end

      response '404', 'document not found' do
        let(:id) { 'invalid_id' }
        run_test! do
          # Your test code here for when the document is not found
        end
      end
    end
  end
end
