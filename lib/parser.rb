Game = Struct.new(:home, :away, :time)

class Parser
  def parse(game_str)
    Game.new('Jacksonville Jaguars',
             'Cincinnati Bengals',
             Time.new(2014,nil,nil,13,00))
  end
end
