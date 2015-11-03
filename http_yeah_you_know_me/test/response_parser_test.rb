require 'pry'
require '../lib/response_parser'
require 'socket'
gem 'minitest', '~> 5.2'
require 'minitest/autorun'

class ResponseParserTest < Minitest::Test
  attr_reader :request_lines, :respone_parser, :client

  def setup
    @response_parser = ResponseParser.new
    @request_lines = ["GET / HTTP/1.1", "Host: 127.0.0.1:9292", "Connection: keep-alive", "Cache-Control: max-age=0", "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8", "Upgrade-Insecure-Requests: 1", "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.80 Safari/537.36", "Accept-Encoding: gzip, deflate, sdch", "Accept-Language: en-US,en;q=0.8"]
    @client = TCPServer.new(9292).accept
  end

  def test_that_formatter_returns_correct_array
    output_array =
    ["Verb: GET", "Path: /", "Protocol: HTTP/1.1",
    "Host: 127.0.0.1",
    "Port: 9292",
    "Origin: 127.0.0.1",
    "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8"]
    assert_equal output_array, @response_parser.formatter(request_lines)
  end

  def test_that_default_response_returns_correct_string
    output_array =
    ["Verb: GET", "Path: /", "Protocol: HTTP/1.1",
    "Host: 127.0.0.1",
    "Port: 9292",
    "Origin: 127.0.0.1",
    "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8"]
    assert_equal output_array.join("\n"), @response_parser.default_response(request_lines, client)
  end

  @client.close

end
