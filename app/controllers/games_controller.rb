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
    @score = session[:score] || 0
    @letters = params[:letters].split('')
    @answer = params[:answer].split('')
    @response = check_answer(@answer, @letters)
    if @response[0] == "C"
      session[:score] = @score + @answer.length
    else
      session[:score] = @score
    end
    @current_score = session[:score]
  end

  def check_answer(answer_array, letters_array)
    test_array = []
    letters_array.each { |e| test_array << e.dup }
    exist = "Congratulations! #{answer_array.join('')} is a valid English word"
    wrong = "Sorry but #{answer_array.join('')} does not seem to be a valid English word"
    answer_array.each do |letter|
      if test_array.reject! { |e| e == letter.downcase }.nil?
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
