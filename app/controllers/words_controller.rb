class WordsController < ApplicationController
  # The API endpoint will be of the form:
  # words/meaning?word=<our_word>
  def meaning
    api_url = "https://api.dictionaryapi.dev/api/v2/entries/en/#{params['word']}"
    response = HTTParty.get(api_url, headers: { 'Content-Type' => 'application/json' })

    return render json: { 'message': 'Word not found' }, status: :not_found unless response.code == 200

    meanings = []
    response.parsed_response[0]['meanings'].each do |meaning|
      meanings.append(meaning['definitions'][0]['definition'])
    end

    render json: meanings
  end

  # The API endpoint will be of the form:
  # words/synonym?word=<our_word>
  def synonym
    api_url = "https://api.dictionaryapi.dev/api/v2/entries/en/#{params['word']}"
    response = HTTParty.get(api_url, headers: { 'Content-Type' => 'application/json' })

    return render json: { 'message': 'Word not found' }, status: :not_found unless response.code == 200

    synonyms = []
    response.parsed_response[0]['meanings'].each do |meaning|
      next if meaning['synonyms'].empty?

      meaning['synonyms'].each do |synonym|
        synonyms.append(synonym)
      end
    end

    synonyms.empty? ? (render json: { message: 'No synonyms found' }) : (render json: synonyms)
  end
end
