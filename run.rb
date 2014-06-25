#!/usr/bin/env ruby

require 'bundler/setup'
require 'pathological'
require 'nokogiri'
require 'net/http'

require 'lib/parser'

URI_PATH = 'http://www.usatoday.com/story/sports/nfl/2014/04/23/2014-nfl-schedule-by-week/8072059/'

MONTH_STR_TO_NUM = {'sept' => 9,
                    'oct'  => 10,
                    'nov'  => 11,
                    'dec'  => 12}
DATE_REGEX = /^(?<month>[a-z]+)\. (?<day>\d+)$/i

parser = Parser.new
doc = Nokogiri::HTML( Net::HTTP.get( URI(URI_PATH) ) )

cur_month = 0;
cur_day = 0;
doc.css('div[@itemprop="articleBody"] p').each do |ptag|
  content = ptag.content.strip
  if ( matches = DATE_REGEX.match content )
    cur_month = MONTH_STR_TO_NUM[matches[:month].downcase]
    cur_day = matches[:day].to_i
    puts "Set: #{cur_month} #{cur_day}"
  elsif ( game = parser.parse_game(content, 2014, cur_month, cur_day) )
    puts game
  else
    #puts "No match: #{content}"
  end
end
