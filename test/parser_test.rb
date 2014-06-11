require 'bundler/setup'
require 'pathological'
require 'minitest/autorun'

require 'lib/parser'

class ParserTest < MiniTest::Unit::TestCase
  def setup
    @parser = Parser.new
  end

  def test_parses_game_v1
    v1 = 'Jacksonville Jaguars at Cincinnati Bengals, 1'
    game = @parser.parse v1
    assert_equal game.home, 'Jacksonville Jaguars'
    assert_equal game.away, 'Cincinnati Bengals'
    assert_equal game.time.strftime('%H:%M'), '13:00'
  end
end

