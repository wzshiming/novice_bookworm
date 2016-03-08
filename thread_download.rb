#!/usr/bin/env ruby 
#-*- coding:utf-8 -*- 


require './thread_size'
require './request'
require './puts'


def download_range url, range, size=1024
	beg = range * size
	html = request :get,url,{}, {'Range' => "bytes=#{beg}-#{beg + size - 1}"}
  html.to_hash['content-range'][0].scan(/bytes (\d+)-(\d+)\/(\d+)/)[0].unshift html.body
end

class Thread_size
  def thread_download url, range, size=1024, &block
    add do
      block.call download_range url, range, size
    end
  end
end

def thread_downloads url, thread_size=4, block_size=1024, &block
	download = Thread_size.new thread_size
	download.thread_download url, 0, 10 do |ret|
		size  = ret[3].to_i / block_size + 1
		size.times do |index|
			download.thread_download url, index, block_size do |ret2|
				block.call *ret2
				print "#{download.info}\r"
			end
		end
	end
	download.join
end

if $0 == __FILE__
	u = 'http://img1.gamersky.com/image2014/06/20140627tqy_2/gamersky_04origin_07_20146271915D65.jpg'
	fout={}
	thread_downloads u, 8, 102400 do|data,pos,ends,size|
		fout[pos.to_i] = data
	end
	open './download/a.jpg','wb+' do |out|
		fout.each do |key,value|
			out.seek key
			out << value
		end
	end
end