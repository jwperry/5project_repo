require 'pry'
require 'socket'
require './response_parser'
require_relative 'parser'

parser = Parser.new
response_parser = ResponseParser.new
tcp_server = TCPServer.new(9292)

counter = 0
hello_counter = 0

loop do
  counter += 1
  client = tcp_server.accept
  puts "Ready for a request"
  request_lines = []
  while line = client.gets and !line.chomp.empty?
    request_lines << line.chomp
  end

  if parser.get_path(request_lines).start_with?("/word_search")
    word = parser.get_word(parser.get_path(request_lines))
    response_parser.word_search_response(client, word)
  elsif parser.get_path(request_lines) == "/hello"
    response_parser.hello_response(client, hello_counter)
    hello_counter += 1
  elsif parser.get_path(request_lines) == "/datetime"
    response_parser.datetime_response(client)
  elsif parser.get_path(request_lines) == "/shutdown"
    response_parser.shutdown_response(counter, client)
    client.close
    break
  else
    response_parser.default_response(request_lines, client)
  end

  puts "Got this request:"
  puts request_lines.inspect
end

# parser.default_response(request_lines, client)
# /hello /datetime /shutdown
#
# case parser.get_path(request_lines)
# when "/word_search"
#   parser.word_search(client)
# when "/hello"
#   parser.hello_response(client, hello_counter)
#   hello_counter += 1
# when "/datetime"
#   parser.datetime_response(client)
# when "/shutdown"
#   parser.shutdown_response(counter, client)
#   client.close
#   break
# else
#   parser.default_response(request_lines, client)
# end
