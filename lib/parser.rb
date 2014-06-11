Game = Struct.new(:home, :away, :time, :can_flex?)

# Note that this assumes that all times are EST PM
class Parser
  REGEX = /(?<home_team>.+) at (?<away_team>\w+ (\w+)+).*, (?<time_hours>\d+)(:(?<time_mins>\d+))?(?<is_flex>\*)?/

  def parse(game_str)
    matches = REGEX.match game_str
    return nil unless matches
    adjusted_time = Time.new(2014,nil,nil,
                             (matches[:time_hours].to_i % 12) + 12,
                             matches[:time_mins].to_i)
    Game.new(matches[:home_team], matches[:away_team], adjusted_time, matches[:is_flex])
  end
end
