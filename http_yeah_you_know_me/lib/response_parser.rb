require 'date'
require_relative 'parser'

class ResponseParser
  attr_reader :parser

  def initialize
    @parser = Parser.new
  end

  def formatter(request_lines)
    response = []
    response << "Verb: #{parser.get_verb(request_lines)}"
    response << "Path: #{parser.get_path(request_lines)}"
    response << "Protocol: #{parser.get_protocol(request_lines)}"
    response << "Host: #{parser.get_host(request_lines)}"
    response << "Port: #{parser.get_port(request_lines)}"
    response << "Origin: #{parser.get_origin(request_lines)}"
    response << "Accept: #{parser.get_accept(request_lines)}"
  end

  def default_response(request_lines)
    puts "Sending response."
    response = "<pre>" + formatter(request_lines).join("\n") + "</pre>"
    "<html><head></head><body>#{response}</body></html>"
  end

  def hello_response(hello_counter)
    response = "<pre>" + "Hello world! (#{hello_counter})" + "</pre>"
    output = "<html><head></head><body>#{response}</body></html>"
  end

  def datetime_response
    time = DateTime.now
    time_response = time.strftime('%l:%M%P on %A, %B %-d, %Y')
    response = "<pre>" + "#{time_response}" + "</pre>"
    "<html><head></head><body>#{response}</body></html>"
  end

  def shutdown_response(counter)
    response = "<pre>" + "Total Requests: (#{counter})" + "</pre>"
    "<html><head></head><body>#{response}</body></html>"
  end

  def word_search_response(word)
    if check_for_word(word)
      response = "<pre>" + "#{word.upcase} is a known word." + "</pre>"
    else
      response = "<pre>" + "#{word.upcase} is not a known word." + "</pre>"
    end
    "<html><head></head><body>#{response}</body></html>"
  end

  def check_for_word(word)
    dictionary = File.read("/usr/share/dict/words")
    dictionary.include?(word)
  end
end
