Game = Struct.new(:home, :away, :time, :flex?) do
  def can_flex?
    !!flex?
  end
end

# Parser assumes that all times are EST PM
#
# Sample entries:
# New Orleans Saints at Atlanta Falcons, 1
# St. Louis Rams at San Francisco 49ers, 4:05
# Detroit Lions at Atlanta Falcons (LONDON), 9:30a
class Parser
  REGEX = /(?<away_team>.+) at (?<home_team>\w+\.?( \w+)+).*, (?<time_hours>\d+)(:(?<time_mins>\d+))?(?<is_am>a)?(?<is_flex>\*)?/

  def parse(game_str)
    matches = REGEX.match game_str
    return nil unless matches
    time_offset = ( matches[:is_am] ? 0 : 12 )
    adjusted_time = Time.new(2014,nil,nil,
                             (matches[:time_hours].to_i % 12) + time_offset,
                             matches[:time_mins].to_i)
    Game.new(matches[:home_team], matches[:away_team], adjusted_time, matches[:is_flex])
  end
end
