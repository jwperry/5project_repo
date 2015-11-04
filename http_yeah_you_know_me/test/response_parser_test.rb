require 'pry'
require './lib/response_parser'
require 'socket'
gem 'minitest', '~> 5.2'
require 'minitest/autorun'

class ResponseParserTest < Minitest::Test
  attr_reader :request_lines, :respone_parser

  def setup
    @response_parser = ResponseParser.new
    @request_lines = ["GET / HTTP/1.1", "Host: 127.0.0.1:9292", "Connection: keep-alive", "Cache-Control: max-age=0", "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8", "Upgrade-Insecure-Requests: 1", "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.80 Safari/537.36", "Accept-Encoding: gzip, deflate, sdch", "Accept-Language: en-US,en;q=0.8"]
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
    ["<html><head></head><body><pre>Verb: GET", "Path: /", "Protocol: HTTP/1.1",
    "Host: 127.0.0.1",
    "Port: 9292",
    "Origin: 127.0.0.1",
    "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8</pre></body></html>"]
    assert_equal output_array.join("\n"), @response_parser.default_response(request_lines)
  end

  def test_hello_response_returns_correct_string
    hello_counter = 5
    response = "<html><head></head><body><pre>Hello world! (5)</pre></body></html>"
    assert_equal response, @response_parser.hello_response(hello_counter)
  end

  def test_that_datetime_response_returns_correct_string
    time = DateTime.now
    response = time.strftime('%l:%M%P on %A, %B %-d, %Y')
    assert_equal "<html><head></head><body><pre>" + response + "</pre></body></html>", @response_parser.datetime_response
  end

  def test_that_shutdown_response_returns_correct_string
    response = "<html><head></head><body><pre>Total Requests: (5)</pre></body></html>"
    assert_equal response, @response_parser.shutdown_response(5)
  end

  def test_that_check_for_word_finds_real_word
    assert @response_parser.check_for_word("car")
  end

  def test_that_check_for_word_returns_false_for_fake_word
    refute @response_parser.check_for_word("aanoks")
  end

  def test_that_word_search_response_returns_correct_string_if_word_is_known
    response = "<html><head></head><body><pre>" + "HAT is a known word." + "</pre></body></html>"
    assert_equal response, @response_parser.word_search_response("hat")
  end

  def test_that_word_search_response_returns_correct_string_if_word_is_unknown
    response = "<html><head></head><body><pre>" + "HATTT is not a known word." + "</pre></body></html>"
    assert_equal response, @response_parser.word_search_response("hattt")
  end

end
