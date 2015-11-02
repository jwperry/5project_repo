require 'pry'
require 'socket'
require './response_parser'

parser = ResponseParser.new
tcp_server = TCPServer.new(9292)
count = 0

client = tcp_server.accept
puts "Ready for a request"
request_lines = []
while line = client.gets and !line.chomp.empty?
  request_lines << line.chomp
end
puts "Got this request:"
puts request_lines.inspect

parser.default_response(request_lines, client)
