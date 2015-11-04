require_relative 'parser'

class Game
  attr_reader :parser
  attr_accessor :guess_counter

  def initialize
    @guess_counter = 0
    @number = rand(1..10)
    @parser = Parser.new
  end

  def start_game?(request_lines, path)
    game = @parser.get_verb(request_lines) == "POST" && path.start_with?("/start_game")
    @guess_counter = 0 if game
    game
  end

  def check_guess(guess)
    @guess_counter += 1
    return "Correct!" if guess.to_i == @number
    return "#{guess} is too low!" if guess.to_i < @number
    return "#{guess} is too high!" if guess.to_i > @number
  end

  def guesses_made
    @guess_counter
  end







end
