require 'nokogiri'
require 'open-uri'

class GamesController < ApplicationController
  ALPHABET = ('a'..'z').to_a
  def new
    @letters = []
    10.times do
      @letters << ALPHABET.sample
    end
  end

  def score
    @letters = params[:letters].split('')
    @answer = params[:answer].split('')
    @response = check_answer(@answer, @letters)
    # raise
  end

  def check_answer(answer_array, letters_array)
    exist = "Congratulations! #{answer_array.join('')} is a valid English word"
    wrong = "Sorry but #{answer_array.join('')} does not seem to be a valid English word"
    answer_array.each do |letter|
      if letters_array.reject! { |e| e == letter.downcase }.nil?
        return "Sorry but #{answer_array.join('')} can't be built out of #{letters_array.join(', ')}"
      end
    end
    call_dictionary(answer_array.join('')) ? (return exist) : (return wrong)
  end

  def call_dictionary(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    data = open(url).read
    parsed_data = JSON.parse(data)
    return parsed_data['found']
  end
end
