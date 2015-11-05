require 'pry'
require_relative 'game'
require_relative 'response_parser'
require_relative 'parser'

class Server
  attr_accessor :request_lines, :hello_counter

  def initialize
    @parser = Parser.new
    @game = Game.new
    @response_parser = ResponseParser.new
    @guess = ""
    @hello_counter = 0
  end

  def get_verb
    @parser.get_verb(@request_lines)
  end

  def get_path
    @parser.get_path(@request_lines)
  end

  def update_request_lines(request_lines)
    @request_lines = request_lines
  end

  def game_in_progress(guess_counter, client)
    if get_path.start_with?("/start_game") && @game.guess_counter > 0
      client.puts "HTTP/1.1 403 Forbidden\r\n\r\n#{"403 Forbidden\nGame in progress!"}"
      return get_path.start_with?("/start_game") && @game.guess_counter > 0
    end
  end

  def start_game(client)
    if @game.start_game?(@request_lines, get_path)
      client.puts "<pre> Good Luck! Use /start_game after guessing correctly to restart! </pre>"
      return @game.start_game?(@request_lines, get_path)
    end
  end

  def redirect(client, guess)
    if get_path.start_with?("/game") && get_verb == "POST"
      @guess = guess
      client.puts "HTTP/1.1 302 Found\r\nLocation: http://127.0.0.1:9292/game"
      return get_path.start_with?("/game") && get_verb == "POST"
    end
  end

  def new_game_redirect(client)
    if x = get_path.start_with?("/new_game")
      client.puts "HTTP/1.1 302 Found\r\nLocation: http://127.0.0.1:9292/start_game"
      return x
    end
  end

  def check_guess(client)
    if get_path.start_with?("/game")
      answer = @game.answer
      output = @game.check_guess(@guess, answer)
      client.puts "HTTP/1.1 200 OK\r\n\r\n#{output}"
      return get_path.start_with?("/game")
    end
  end

  def word_search(client)
    if get_path.start_with?("/word_search")
      word = @parser.get_word(get_path)
      output = @response_parser.word_search_response(word)
      client.puts "HTTP/1.1 200 OK\r\n\r\n#{output}"
      return get_path.start_with?("/word_search")
    end
  end

  def hello(client)
    if get_path == "/hello"
      @hello_counter += 1
      output = @response_parser.hello_response(@hello_counter)
      client.puts "HTTP/1.1 200 OK\r\n\r\n#{output}"
      return get_path == "/hello"
    end
  end

  def date_time(client)
    if get_path == "/datetime"
      output = @response_parser.datetime_response
      client.puts "HTTP/1.1 200 OK\r\n\r\n#{output}"
      return get_path == "/datetime"
    end
  end

  def shutdown(client, counter)
    if get_path == "/shutdown"
      output = @response_parser.shutdown_response(counter)
      client.puts "HTTP/1.1 200 OK\r\n\r\n#{output}"
      client.close
      return get_path == "/shutdown"
    end
  end

  def default_response(client)
    if get_path == "/"
      output = @response_parser.default_response(@request_lines)
      client.puts "HTTP/1.1 200 OK\r\n\r\n#{output}"
      return get_path == "/"
    end
  end

  def force_error(client)
    if get_path == "/force_error"
      client.puts "HTTP/1.1 500 INTERNAL SERVER ERROR \r\n\r\n500 Internal Server Error\r\nSystem Error\r\n#{caller.join("\n")}"
      return get_path == "/force_error"
    end
  end

  def not_found(client)
    client.puts "HTTP/1.1 404 NOT FOUND\r\n\r\n404 NOT FOUND"
  end

end
