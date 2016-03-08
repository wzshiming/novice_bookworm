#!/usr/bin/env ruby 
#-*- coding:utf-8 -*- 

def times &block
  start_time=Time.now
  puts "Start at #{start_time}"
  block.call
  end_time=Time.now
  puts "End at #{end_time}"
  puts "With time #{(end_time-start_time).ceil} S"
end
