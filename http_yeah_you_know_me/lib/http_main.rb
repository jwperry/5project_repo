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

loop do
  counter += 1
  request_lines = []
  puts "Ready for a request"
  client = tcp_server.accept

  # "POST /game?guess=4 HTTP/1.1",

  while line = client.gets and !line.chomp.empty?
    request_lines << line.chomp
  end

  path = parser.get_path(request_lines)
  client.puts "<pre> Good Luck! </pre>" if game.start_game?(request_lines, path)
  if path.start_with?("/game") && parser.get_verb(request_lines) == "POST"
    guess = parser.get_guess(path)
    `curl -G --data guess=6 "127.0.0.1.9292/game"`
  elsif path.start_with?("/game")
    guess = parser.get_guess(path)
    output = game.check_guess(guess)
    client.puts output
  elsif path.start_with?("/word_search")
    word = parser.get_word(path)
    output = response_parser.word_search_response(word)
    client.puts output
  elsif path == "/hello"
    hello_counter += 1
    output = response_parser.hello_response(hello_counter)
    client.puts output
  elsif path == "/datetime"
    output = response_parser.datetime_response
    client.puts output
  elsif path == "/shutdown"
    output = response_parser.shutdown_response(counter)
    client.puts output
    client.close
    break
  else
    output = response_parser.default_response(request_lines)
    client.puts output
  end

  puts "Got this request:"
  puts request_lines.inspect

end
