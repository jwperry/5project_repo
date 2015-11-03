require 'pry'
require '../lib/response_parser'
gem 'minitest', '~> 5.2'
require 'minitest/autorun'

class ResponseParserTest < Minitest::Test
  attr_reader :parser, :request_lines

  def setup
    @client = ""
    @parser = ResponseParser.new
    @request_lines = ["GET / HTTP/1.1", "Host: 127.0.0.1:9292", "Connection: keep-alive", "Cache-Control: max-age=0", "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8", "Upgrade-Insecure-Requests: 1", "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.80 Safari/537.36", "Accept-Encoding: gzip, deflate, sdch", "Accept-Language: en-US,en;q=0.8"]
  end

  def test_that_gets_verb
    assert_equal "GET", parser.get_verb(request_lines)
  end

  def test_that_gets_path
    assert_equal "/", parser.get_path(request_lines)
  end

  def test_that_gets_protocol
    assert_equal "HTTP/1.1", parser.get_protocol(request_lines)
  end

  def test_that_gets_host
    assert_equal "127.0.0.1", parser.get_host(request_lines)
  end

  def test_that_gets_port
    assert_equal "9292", parser.get_port(request_lines)
  end

  def test_that_gets_origin
    skip
    assert_equal "127.0.0.1", parser.get_origin(request_lines)
  end

  def test_that_gets_accept
    assert_equal "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8", parser.get_accept(request_lines)
  end

  

end
