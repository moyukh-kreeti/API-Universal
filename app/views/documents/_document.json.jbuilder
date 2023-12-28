json.extract! document, :id, :filename, :created_at, :updated_at
json.url document_url(document, format: :json)
