#!/usr/bin/env ruby 
#-*- coding:utf-8 -*- 

require 'uri'
require 'net/http'
require 'net/https'

def request name, path, data = nil, header = nil
  uri = URI path
  uri.query = URI.encode_www_form data if data
  https = Net::HTTP.new uri.host, uri.port
  https.use_ssl = true if uri.scheme == 'https'
  header['Referer'] = "#{uri.host}#{uri.port}" if header
  https.send name, uri, header
end
