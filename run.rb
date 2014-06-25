#!/usr/bin/env ruby

require 'bundler/setup'
require 'pathological'

require 'lib/parser'

SPACER = '    '
DATE_STR_FMT = '%A, %b %e'

last_day = nil
Parser::parse_sched.each do |game|
  game_day = game.time.day
  if last_day.nil? || !last_day.eql?(game_day)
    puts game.time.strftime(DATE_STR_FMT)
    last_day = game_day
  end

  puts "#{SPACER}#{game.home} vs #{game.away}"
end
