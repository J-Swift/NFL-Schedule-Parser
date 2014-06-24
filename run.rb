#!/usr/bin/env ruby

require 'bundler/setup'
require 'pathological'
require 'nokogiri'
require 'net/http'

require 'lib/parser'

URI_PATH = 'http://www.usatoday.com/story/sports/nfl/2014/04/23/2014-nfl-schedule-by-week/8072059/'

parser = Parser.new
doc = Nokogiri::HTML( Net::HTTP.get( URI(URI_PATH) ) )
doc.css('div[@itemprop="articleBody"] p').each do |ptag|
  game = parser.parse ptag.content
  puts game if game
end
