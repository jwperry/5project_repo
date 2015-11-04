require 'pry'
require 'socket'
require_relative 'response_parser'
require_relative 'parser'
require_relative 'game'

parser = Parser.new
response_parser = ResponseParser.new
tcp_server = TCPServer.new(9292)
game = Game.new

counter = 0
hello_counter = 0
guess = 0

loop do
  counter += 1
  request_lines = []
  puts "Ready for a request"
  client = tcp_server.accept

  while line = client.gets and !line.chomp.empty?
    request_lines << line.chomp
  end
  verb = parser.get_verb(request_lines)
  path = parser.get_path(request_lines)

  #client.puts "<pre> Good Luck! </pre>" if game.start_game?(request_lines, path) && game.guess_counter == 0
  if verb == "POST" && path.start_with?("/start_game") && game.guess_counter > 0
    client.puts "HTTP/1.1 403 Forbidden\r\n\r\n#{"403 Forbidden\nGame in progress!"}"
  elsif game.start_game?(request_lines, path)
    client.puts "<pre> Good Luck! Use /start_game after guessing correctly to restart! </pre>"
  elsif path.start_with?("/game") && verb == "POST"
    guess = parser.get_guess(path)
    client.puts "HTTP/1.1 302 Found\r\nLocation: http://127.0.0.1:9292/game"
  elsif path.start_with?("/game")
    answer = game.answer
    output = game.check_guess(guess, answer)
    client.puts "HTTP/1.1 200 OK\r\n\r\n#{output}"
  elsif path.start_with?("/word_search")
    word = parser.get_word(path)
    output = response_parser.word_search_response(word)
    client.puts "HTTP/1.1 200 OK\r\n\r\n#{output}"
  elsif path == "/hello"
    hello_counter += 1
    output = response_parser.hello_response(hello_counter)
    client.puts "HTTP/1.1 200 OK\r\n\r\n#{output}"
  elsif path == "/datetime"
    output = response_parser.datetime_response
    client.puts "HTTP/1.1 200 OK\r\n\r\n#{output}"
  elsif path == "/shutdown"
    output = response_parser.shutdown_response(counter)
    client.puts "HTTP/1.1 200 OK\r\n\r\n#{output}"
    client.close
    break
  elsif path == "/"
    output = response_parser.default_response(request_lines)
    client.puts "HTTP/1.1 200 OK\r\n\r\n#{output}"
  elsif path == "/force_error"
    client.puts "HTTP/1.1 500 INTERNAL SERVER ERROR \r\n\r\n500 Internal Server Error"
    raise 'SystemError'
  else
    client.puts "HTTP/1.1 404 NOT FOUND\r\n\r\n404 NOT FOUND"
  end

  puts "Got this request:"
  puts request_lines.inspect
  client.close

end