class WordsController < ApplicationController
  def get_word
    url='https://api.dictionaryapi.dev/api/v2/entries/en/'+params[:word]
    response = HTTParty.get(url)
    # binding.pry
    render json: response[0]
  end
end
