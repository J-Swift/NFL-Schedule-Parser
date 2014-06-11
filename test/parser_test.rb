require 'bundler/setup'
require 'pathological'
require 'minitest/autorun'

require 'lib/parser'

class ParserTest < MiniTest::Unit::TestCase
  def setup
    @parser = Parser.new
  end

  def validate_parse(game, expected_home, expected_away, expected_time)
    assert_equal expected_home, game.home
    assert_equal expected_away, game.away
    assert_equal expected_time, game.time.strftime('%H:%M')
  end

  def test_short_time_string
    game = @parser.parse 'Jacksonville Jaguars at Cincinnati Bengals, 1'
    validate_parse(game, 'Jacksonville Jaguars', 'Cincinnati Bengals', '13:00')
  end

  def test_full_time_string
    game = @parser.parse 'New York Giants at Seattle Seahawks, 4:25'
    validate_parse(game, 'New York Giants', 'Seattle Seahawks', '16:25')
  end

  def test_extraneous_info
    game = @parser.parse 'Miami Dolphins at Oakland Raiders (LONDON), 1'
    validate_parse(game, 'Miami Dolphins', 'Oakland Raiders', '13:00')
  end

  def test_flex_schedule
    game = @parser.parse 'San Francisco 49ers at Denver Broncos, 8:30*'
    validate_parse(game, 'San Francisco 49ers', 'Denver Broncos', '20:30')
    assert game.can_flex?

    game = @parser.parse 'San Francisco 49ers at Denver Broncos, 8:30'
    validate_parse(game, 'San Francisco 49ers', 'Denver Broncos', '20:30')
    refute game.can_flex?
  end

  def test_handles_noon
    game = @parser.parse 'Chicago Bears at Detroit Lions, 12:30'
    validate_parse(game, 'Chicago Bears', 'Detroit Lions', '12:30')
  end

  def test_invalid_parse_returns_nil
    game = @parser.parse 'gibberish agoodojrj ofojoj409 j9j 2j11 j9'
    assert_nil game
  end

  def test_handles_st_louis_rams
    game = @parser.parse 'Minnesota Vikings at St. Louis Rams, 1'
    validate_parse(game, 'Minnesota Vikings', 'St. Louis Rams', '13:00')

    game = @parser.parse 'St. Louis Rams at Seattle Seahawks, 4:25'
    validate_parse(game, 'St. Louis Rams', 'Seattle Seahawks', '16:25')
  end
end

