require 'pry'
require './lib/game'
gem 'minitest', '~> 5.2'
require 'minitest/autorun'

class GameTest < Minitest::Test

  def test_game_counter_zero_when_initialized
    game = Game.new
    assert_equal 0, game.guess_counter
  end

  def test_starts_game
    game = Game.new
    request_lines = ["POST /start_game HTTP/1.1", "Host: 127.0.0.1:9292", "Connection: keep-alive", "Cache-Control: max-age=0", "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8", "Upgrade-Insecure-Requests: 1", "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.80 Safari/537.36", "Accept-Encoding: gzip, deflate, sdch", "Accept-Language: en-US,en;q=0.8"]
    path = "/start_game"
    assert game.start_game?(path)
  end

  def test_check_guess_zeroes_is_correct
    game = Game.new
    request_lines = ["POST /start_game HTTP/1.1", "Host: 127.0.0.1:9292", "Connection: keep-alive", "Cache-Control: max-age=0", "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8", "Upgrade-Insecure-Requests: 1", "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.80 Safari/537.36", "Accept-Encoding: gzip, deflate, sdch", "Accept-Language: en-US,en;q=0.8"]
    path = "/start_game"
    game.start_game?(path)
    assert_equal "0 is correct! You may start a new game now.", game.check_guess(0, 0)
  end

  def test_game_rejects_non_intiger_guess
    game = Game.new
    request_lines = ["POST /start_game HTTP/1.1", "Host: 127.0.0.1:9292", "Connection: keep-alive", "Cache-Control: max-age=0", "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8", "Upgrade-Insecure-Requests: 1", "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.80 Safari/537.36", "Accept-Encoding: gzip, deflate, sdch", "Accept-Language: en-US,en;q=0.8"]
    path = "/start_game"
    game.start_game?(path)
    assert_equal "g is not a number 0-10!", game.check_guess("g", 9)
  end

  def test_check_guess_is_correct
    game = Game.new
    request_lines = ["POST /start_game HTTP/1.1", "Host: 127.0.0.1:9292", "Connection: keep-alive", "Cache-Control: max-age=0", "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8", "Upgrade-Insecure-Requests: 1", "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.80 Safari/537.36", "Accept-Encoding: gzip, deflate, sdch", "Accept-Language: en-US,en;q=0.8"]
    path = "/start_game"
    game.start_game?(path)
    assert_equal "8 is correct! You may start a new game now.", game.check_guess(8, 8)
  end

  def test_check_guess_is_too_low
    game = Game.new
    request_lines = ["POST /start_game HTTP/1.1", "Host: 127.0.0.1:9292", "Connection: keep-alive", "Cache-Control: max-age=0", "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8", "Upgrade-Insecure-Requests: 1", "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.80 Safari/537.36", "Accept-Encoding: gzip, deflate, sdch", "Accept-Language: en-US,en;q=0.8"]
    path = "/start_game"
    game.start_game?(path)
    assert_equal "1 is too low!", game.check_guess(1, 5)
  end

  def test_check_guess_is_too_high
    game = Game.new
    request_lines = ["POST /start_game HTTP/1.1", "Host: 127.0.0.1:9292", "Connection: keep-alive", "Cache-Control: max-age=0", "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8", "Upgrade-Insecure-Requests: 1", "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.80 Safari/537.36", "Accept-Encoding: gzip, deflate, sdch", "Accept-Language: en-US,en;q=0.8"]
    path = "/start_game"
    game.start_game?(path)
    assert_equal "9 is too high!", game.check_guess(9, 5)
  end

  def test_check_guess_counter
    game = Game.new
    request_lines = ["POST /start_game HTTP/1.1", "Host: 127.0.0.1:9292", "Connection: keep-alive", "Cache-Control: max-age=0", "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8", "Upgrade-Insecure-Requests: 1", "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.80 Safari/537.36", "Accept-Encoding: gzip, deflate, sdch", "Accept-Language: en-US,en;q=0.8"]
    path = "/start_game"
    game.start_game?(path)
    game.check_guess(1, 5)
    game.check_guess(2, 5)
    assert_equal 2, game.guess_counter
  end

  def test_start_game_resets_guess_counter
    game = Game.new
    request_lines = ["POST /start_game HTTP/1.1", "Host: 127.0.0.1:9292", "Connection: keep-alive", "Cache-Control: max-age=0", "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8", "Upgrade-Insecure-Requests: 1", "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.80 Safari/537.36", "Accept-Encoding: gzip, deflate, sdch", "Accept-Language: en-US,en;q=0.8"]
    path = "/start_game"
    game.start_game?(path)
    assert_equal 0, game.guess_counter
    game.check_guess(1, 8)
    game.check_guess(2, 7)
    assert_equal 2, game.guess_counter
    game.start_game?(path)
    assert_equal 0, game.guess_counter
  end
end
