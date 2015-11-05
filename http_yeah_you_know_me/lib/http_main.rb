require 'socket'
require_relative 'game'
require_relative 'server'
tcp_server = TCPServer.new(9292)
game = Game.new
server = Server.new
counter = 0

loop do
  counter += 1
  request_lines = []
  puts "Ready for a request"
  client = tcp_server.accept

  while line = client.gets and !line.ecmpty?
    request_lines << line.chomp
    guess = request_lines.last if request_lines.length == 17
    break if request_lines.length > 16
    break if request_lines.first.split(" ")[0] == "GET" && line.chomp.empty?
  end

  server.update_request_lines(request_lines)
  break if server.shutdown(client, counter)
  if server.redirect(client, guess)
  elsif server.game_in_progress(game.guess_counter, client)
  elsif server.start_game(client)
  elsif server.new_game_redirect(client)
  elsif server.check_guess(client)
  elsif server.word_search(client)
  elsif server.hello(client)
  elsif server.date_time(client)
  elsif server.default_response(client)
  elsif server.force_error(client)
  else server.not_found(client)
  end

  puts "Got this request:"
  puts request_lines.inspect
  client.close
end
