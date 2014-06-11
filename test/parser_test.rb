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

  def test_parses_normal_1
    game = @parser.parse 'Jacksonville Jaguars at Cincinnati Bengals, 1'
    validate_parse(game, 'Jacksonville Jaguars', 'Cincinnati Bengals', '13:00')
  end

  def test_parses_normal_2
    game = @parser.parse 'New York Giants at Seattle Seahawks, 4:25'
    validate_parse(game, 'New York Giants', 'Seattle Seahawks', '16:25')
  end

  def test_parses_funky_1
    game = @parser.parse 'Miami Dolphins at Oakland Raiders (LONDON), 1'
    validate_parse(game, 'Miami Dolphins', 'Oakland Raiders', '13:00')
  end
end

