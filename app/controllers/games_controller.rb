require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    alphabet = ('A'..'Z').to_a
    @letters = Array.new(10) { alphabet.to_a.sample }
  end

  def fetch(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    result_serialized = open(url).read
    feedback = JSON.parse(result_serialized)
    feedback['found']
  end

  def grid?(word)
    word.chars.each do |l|
      return false unless word.count(l) <= @grid.join.count(l)
    end
    true
  end

  def score
    @word = params[:word]
    @grid = params[:letters].split.map(&:downcase)
    @score = 0
    @result = 'Not in the grid' unless grid?(@word)
    if grid?(@word) && fetch(@word)
      @result = 'Your word is english'
      @score += @word.length * @word.length
    else
      @result = 'Your word is not english'
    end
  end
end
