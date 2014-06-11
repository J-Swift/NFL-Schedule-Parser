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

  def test_parses_game_v1
    v1 = 'Jacksonville Jaguars at Cincinnati Bengals, 1'
    game = @parser.parse v1
    validate_parse(game, 'Jacksonville Jaguars', 'Cincinnati Bengals', '13:00')
  end

  def test_parses_game_v2
    v2 = 'New York Giants at Seattle Seahawks, 4:25'
    game = @parser.parse v2
    validate_parse(game, 'New York Giants', 'Seattle Seahawks', '16:25')
  end
end

