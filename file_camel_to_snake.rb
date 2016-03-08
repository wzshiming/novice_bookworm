#!/usr/bin/env ruby 
#-*- coding:utf-8 -*- 
require './camel_to_snake'
require './string_boost'
require 'set'

if $0 == __FILE__
	puts $*
	$*.each do |filename|
		open filename, 'r' do |text|
			txt = text.read.to_utf8!
			Set.new(txt.scan(/[A-Za-z]+/)).sort{|x| x.size}.each do |value|
				tren = value.camel_to_snake
				puts "#{value} -> #{tren}"
				txt.gsub! value,tren if value != tren
			end
			open "./out/#{filename.split('.').map do |x| x. camel_to_snake end.join('.')}", 'w' do |file|
				file << txt
			end
		end
	end
end