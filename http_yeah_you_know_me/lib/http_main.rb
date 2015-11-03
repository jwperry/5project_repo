require 'pry'
require 'socket'
require './response_parser'

parser = ResponseParser.new
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
  puts "Got this request:"
  puts request_lines.inspect
  case parser.get_path(request_lines)
  when "/hello"
    parser.hello_response(client, hello_counter)
    hello_counter += 1
  when "/datetime"
    parser.datetime_response(client)
  when "/shutdown"
    parser.shutdown_response(counter, client)
    client.close
    break
  else
    parser.default_response(request_lines, client)
  end

end

# parser.default_response(request_lines, client)
# /hello /datetime /shutdown
