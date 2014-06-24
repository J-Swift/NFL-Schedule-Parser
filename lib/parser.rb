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
  REGEX = %r{
    (?<away_team>.+)              # Greedy capture since we can match the 'at' as a delimeter
    \sat\s
    (?<home_team>\w+\.?(\s\w+)+)  # More complex matcher due to no reliable signposts
    .*,\s                         # Note that we throw away anything between the away_team and the comma
    (?<time_hours>\d+)
    (:(?<time_mins>\d+))?         # Minutes portion is optional
    (?<is_am>a)?                  # AM portion is optional
    (?<is_flex>\*)?               # Flex portion is optional
  }x

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
