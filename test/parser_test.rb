require 'bundler/setup'
require 'pathological'
require 'minitest/autorun'

require 'lib/parser'

class ParserTest < MiniTest::Unit::TestCase
  def test_short_time_string
    validate_parse('Jacksonville Jaguars at Cincinnati Bengals, 1',
                   'Jacksonville Jaguars', 'Cincinnati Bengals', '13:00')
  end

  def test_invalid_parse_returns_nil
    assert_nil(Parser::parse_game('gibberish agoodojrj ofojoj409 j9j 2j11 j9'))
  end

  def test_full_time_string
    validate_parse('New York Giants at Seattle Seahawks, 4:25',
                   'New York Giants', 'Seattle Seahawks', '16:25')
  end

  def test_extraneous_info
    validate_parse('Miami Dolphins at Oakland Raiders (LONDON), 1',
                   'Miami Dolphins', 'Oakland Raiders', '13:00')
  end

  def test_flex_schedule
    game = validate_parse('San Francisco 49ers at Denver Broncos, 8:30*',
                          'San Francisco 49ers', 'Denver Broncos', '20:30')
    assert game.can_flex?

    game = validate_parse('San Francisco 49ers at Denver Broncos, 8:30',
                          'San Francisco 49ers', 'Denver Broncos', '20:30')
    refute game.can_flex?
  end

  def test_handles_noon
    validate_parse('Chicago Bears at Detroit Lions, 12:30',
                   'Chicago Bears', 'Detroit Lions', '12:30')
  end

  def test_handles_st_louis_rams
    validate_parse('Minnesota Vikings at St. Louis Rams, 1',
                   'Minnesota Vikings', 'St. Louis Rams', '13:00')

    validate_parse('St. Louis Rams at Seattle Seahawks, 4:25',
                   'St. Louis Rams', 'Seattle Seahawks', '16:25')
  end
  
  def test_handles_morning_game
    validate_parse('Detroit Lions at Atlanta Falcons (LONDON), 9:30a',
                   'Detroit Lions', 'Atlanta Falcons', '09:30')
  end

  private

  def validate_parse(str_to_parse, expected_away, expected_home, expected_time)
    game = Parser::parse_game str_to_parse

    assert_equal expected_home, game.home
    assert_equal expected_away, game.away
    assert_equal expected_time, game.time.strftime('%H:%M')

    game
  end

end

