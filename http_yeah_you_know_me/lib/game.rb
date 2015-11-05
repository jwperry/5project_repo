require_relative 'parser'
require 'pry'

class Game
  attr_reader :parser
  attr_accessor :guess_counter, :answer

  def initialize
    @guess_counter = 0
    @parser = Parser.new
    @answer = 0
  end

  def start_game?(request_lines, path)
    game = path.start_with?("/start_game")
    @guess_counter = 0 if game
    @answer = rand(0..10) if game
    game
  end

  def check_guess(guess, answer)
    @guess_counter += 1
    return "#{guess} is not a number 0-10!" unless guess.to_s == (guess.to_i).to_s
    @guess_counter = 0 if guess.to_i == answer
    return "#{guess} is correct!" if guess.to_i == answer
    return "#{guess} is too low!" if guess.to_i < answer
    return "#{guess} is too high!" if guess.to_i > answer
  end
end