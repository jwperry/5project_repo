require 'pry'
require 'socket'
require_relative 'response_parser'
require_relative 'parser'

parser = Parser.new
response_parser = ResponseParser.new
tcp_server = TCPServer.new(9292)

counter = 0
hello_counter = 0

loop do
  counter += 1
  request_lines = []
  client = tcp_server.accept
  puts "Ready for a request"

  while line = client.gets and !line.chomp.empty?
    request_lines << line.chomp
  end

  # if parser.get_verb(request_lines) == "POST"
  #   puts "Totally a post"
  path = parser.get_path(request_lines)
  if path.start_with?("/word_search")
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
