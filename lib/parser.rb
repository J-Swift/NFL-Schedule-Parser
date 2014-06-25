require 'bundler/setup'
require 'pathological'
require 'nokogiri'
require 'net/http'

Game = Struct.new(:home, :away, :time, :flex?) do
  def can_flex?
    !!flex?
  end
end

module Parser
  URI_PATH = 'http://www.usatoday.com/story/sports/nfl/2014/04/23/2014-nfl-schedule-by-week/8072059/'

  GAME_REGEX = /
    (?<away_team>.+)              # Greedy capture since we can match the 'at' as a delimeter
    \sat\s
    (?<home_team>\w+\.?(\s\w+)+)  # More complex matcher due to no reliable signposts
    .*,\s                         # Note that we throw away anything between the home_team and the comma
    (?<time_hours>\d+)
    (:(?<time_mins>\d+))?         # Minutes portion is optional
    (?<is_am>a)?                  # AM portion is optional
    (?<is_flex>\*)?               # Flex portion is optional
  /x

  DATE_REGEX = /^(?<month>[a-z]+)\. (?<day>\d+)$/i
  MONTH_STR_TO_NUM = {'sept' => 9,
                      'oct'  => 10,
                      'nov'  => 11,
                      'dec'  => 12}

  def self.parse_sched(uri_path = URI_PATH)
    doc = Nokogiri::HTML( Net::HTTP.get( URI(uri_path) ) )
    items = doc.css('div[@itemprop="articleBody"] p').map{ |ptag| ptag.content.strip }
    parse_sched_iter items.each
  end

  def self.parse_sched_iter(iter)
    games = []
    cur_month = 0;
    cur_day = 0;
    begin
      while (item = iter.next)
        if ( matches = DATE_REGEX.match item )
          cur_month = MONTH_STR_TO_NUM[matches[:month].downcase]
          cur_day = matches[:day].to_i
        elsif ( game = parse_game(item, 2014, cur_month, cur_day) )
          games << game
        else
        end
      end
    rescue StopIteration
    end
    games
  end

  # Assumes that all times are EST PM
  #
  # Sample entries:
  # New Orleans Saints at Atlanta Falcons, 1
  # St. Louis Rams at San Francisco 49ers, 4:05
  # Detroit Lions at Atlanta Falcons (LONDON), 9:30a
  def self.parse_game(game_str, game_year=2014, game_month=nil, game_day=nil)
    matches = GAME_REGEX.match game_str
    return nil unless matches

    time_offset = ( matches[:is_am] ? 0 : 12 )
    adjusted_time = Time.new(game_year, game_month, game_day,
                             (matches[:time_hours].to_i % 12) + time_offset,
                             matches[:time_mins].to_i)
    Game.new(matches[:home_team], matches[:away_team], adjusted_time, matches[:is_flex])
  end
end

