#!/usr/bin/env ruby2.0
require './database'
require './puts'
require 'digest/md5' 
if __FILE__ == $0

  conn=Database.new host: 'localhost', 
                    port: 27017, 
                    database: 'test',  
                    username: 'test',  
                    password: 'test'

  conn.remove_data 'user'
  conn.remove_data 'info'
  conn.remove_data 'text'
  10.times.each do |a|
    conn.new_data 'user', username: "user#{a}",password: Digest::MD5.hexdigest("pwd#{a}")
    conn.info_time 'user',{username: "user#{a}"}, 'self_create_time',''
    20.times.each do |b|
      conn.new_data 'info', title: "info_#{a}_#{b}",text:"text_#{a}_#{b}"
      conn.info_time 'info',{title: "info_#{a}_#{b}"}, 'self_create_time',''
      conn.add_point 'user', {username: "user#{a}"}, 'info', {title: "info_#{a}_#{b}"}
      conn.add_point 'info', {title: "info_#{a}_#{b}"}, 'user', {username: "user#{a}"}
      conn.add_info 'info', {title: "info_#{a}_#{b}"}, "#{a}_#{b}", 'info'
      conn.info_time 'user',{username: "user#{a}"},'test'
    end
  end

  conn.print_all 'info'
  conn.print_all 'user'
  conn.print_all 'text'

  puts conn.base['info'].count
  puts conn.base['user'].count
  
  
end

__END__
