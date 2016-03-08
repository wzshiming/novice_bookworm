#!/usr/bin/env ruby 
#-*- coding:utf-8 -*- 

# require 'string/utf8'
require './request'
require './string_boost'


def full_href path, base=''
  true_path = ''
  if path !~ /^http/
    true_path = "#{base}#{path}"
    if true_path !~ /^http/
      true_path = "http://#{true_path}"
    end
  else
    true_path = "#{path}"
  end
  true_path
end

def get_href_hash html
  Nokogiri::HTML(html).css('a').inject Hash.new do |result, link|
    result[link.content] = link['href']
    result
  end
end

def get_href_array html
  Nokogiri::HTML(html).css('a').inject Array.new do |result, link|
    result << link['href']
    result
  end
end

def search_href name, path, query=nil, coding='GBK'
  query.each do |key,value|
    value.to_s.encode! coding
  end if query and coding
  path = 'http://' + path if path !~ /^http/
  begin
    html = request name, path, query
    body = html.body.to_utf8!
  rescue => err
    puts "#{__FILE__}:#{ __LINE__}:#{err}\n from #{name}"
    return ''
  ensure
    return body
  end
end


def is_href? href
  href and href != '#' and href !~ /^javascript/
end
