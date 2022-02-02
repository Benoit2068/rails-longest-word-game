require "json"
require "open-uri"
class GamesController < ApplicationController

  def new
    @letters = (0...15).map { ('a'..'z').to_a[rand(26)] }
  end

  def score
    @word = params[:word]
    @letters = params[:letters].split(" ")
    if included?(@word, @letters)
      if @reponse = valid?(@word)
        @reponse = "it's an english word your score = #{total_score(calcul_score(@word))}"
      else
        @reponse = "it's not an english word"
      end
    else
      @reponse = "bad word! you don't use letter : #{@letters.join(', ')}"
    end
  end

  def included?(word, letters)
    word.chars.all? { |letter| letters.include? letter }
  end

  def valid?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    world_control = URI.open(url).read
    right_world = JSON.parse(world_control)
    right_world["found"]
  end
  def calcul_score(word)
    word.chars.length
  end

  def total_score(new_score)
    cache = ActiveSupport::Cache::MemoryStore.new
    score = cache.read + new_score
    cache.write = score
  end

end
