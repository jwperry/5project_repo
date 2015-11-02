require 'pry'
require 'socket'
require './response_parser'

parser = ResponseParser.new
tcp_server = TCPServer.new(9292)
count = 0

loop do
  client = tcp_server.accept
  puts "Ready for a request"
  request_lines = []
  while line = client.gets and !line.chomp.empty?
    request_lines << line.chomp
  end
  puts "Got this request:"
  puts request_lines.inspect

  puts "Sending response."
  response = "<pre>" + parser.formatter(request_lines).join("\n") + "</pre>"
  output = "<html><head></head><body>#{response}</body></html>"
  headers =
  client.puts headers
  client.puts output
  count += 1
end

puts ["Wrote this response:", headers, output].join("\n")
client.close
puts "\nResponse complete, exiting."
