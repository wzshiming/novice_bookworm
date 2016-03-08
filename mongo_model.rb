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

  conn.removeData 'user'
  conn.removeData 'info'
  conn.removeData 'text'
  10.times.each do |a|
    conn.newData 'user', username: "user#{a}",password: Digest::MD5.hexdigest("pwd#{a}")
    conn.infoTime 'user',{username: "user#{a}"}, 'selfCreateTime',''
    20.times.each do |b|
      conn.newData 'info', title: "info_#{a}_#{b}",text:"text_#{a}_#{b}"
      conn.infoTime 'info',{title: "info_#{a}_#{b}"}, 'selfCreateTime',''
      conn.addPoint 'user', {username: "user#{a}"}, 'info', {title: "info_#{a}_#{b}"}
      conn.addPoint 'info', {title: "info_#{a}_#{b}"}, 'user', {username: "user#{a}"}
      conn.addInfo 'info', {title: "info_#{a}_#{b}"}, "#{a}_#{b}", 'info'
      conn.infoTime 'user',{username: "user#{a}"},'test'
    end
  end

  conn.printAll 'info'
  conn.printAll 'user'
  conn.printAll 'text'

  puts conn.base['info'].count
  puts conn.base['user'].count
  
  
end

__END__
