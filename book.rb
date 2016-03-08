#!/usr/bin/env ruby 
#-*- coding:utf-8 -*- 


require 'nokogiri'
require './puts'
require './web_analytic'
require './thread_size'
require './num_cn'
require './string_boost'
load 'init.rb'

class Thread_size
  def add_download name, path, query = nil, coding = 'GBK', &block
    add do
      block.call search_href name, path, query, coding
    end
  end
end

def recursion_download_block datas, html, download, host, coding, &block
  return nil unless html
  hrefs = get_href_hash html
  objhref = hrefs[datas[0]]
  href = full_href objhref, host
  download.add_download :get, href, nil, coding do |html|
    datas.shift
    if datas.size == 0
      block.call href, html
    else
      recursion_download_block datas, html, download, host, coding, &block
    end
  end
end

def value_replace data, rep
  result = nil
  case data
  when Array
    result=[]
    data.each do |value|
      result.push case value
      when Symbol
        if rep[value]
          rep[value].clone
        else
          value
        end
      when Hash, Array
        value_replace value, rep
      else
        value
      end
    end
  when Hash
    result = {}
    data.each do |key, value|
      result[key] = case value
      when Symbol
        if rep[value]
          rep[value].clone
        else
          value
        end
      when Hash, Array
        value_replace value, rep
      else
        value
      end
    end
  end
  result
end

def book_search_index_pape config, download, &block
  search_host = full_href config[:search][:href], config[:host]
  download.add_download config[:search][:type].to_sym, search_host, config[:search][:opt], config[:coding] do |html|
    recursion_download_block config[:confirm], html, download, config[:host], config[:coding] do |href, index_pape|
      doc = Nokogiri::HTML index_pape
      html_href = doc.css config[:listcss]
      all_href = get_href_hash html_href.to_s
      block.call href, all_href, config
    end
  end
end

def book_search_text href, config, download, index = 0, &block
  objhref = full_href href, config[:body][:href]
  download.add_download :get, objhref, nil, config[:coding] do |data|
    doc = Nokogiri::HTML data
    str=''
    doc.css(config[:body][:css]).each do |body|
      text = body.content
      config[:body][:sub].each do |pattern,replacement|
        text.gsub! pattern, replacement
      end
      str += text
    end
    block.call str, index
  end
end
def book_search_text_all hrefs, config, download, &block
  index = 0
  hrefs.each do |key, value|
    book_search_text value, config, download, index += 1 do |text, index|
      block.call index, config[:book_name], key, text
    end
  end
end

def get_qidian_recommend download, &block
  host ='http://all.qidian.com/Ajax.aspx?opName=qd.g.dw.gettopbroadnews&pagePathName='
  download.add_download :get, host, nil, 'UTF-8' do |json|
    block.call json.scan(/BookName:'(.*?)',/).join(',').split(',')
  end
end


if $0 == __FILE__
  download = Thread_size.new 32
  books={}
  get_qidian_recommend download do |datas|
	puts datas
    datas = ["萌娘四海为家","汐言的世界线战争","异界萌灵战姬","震旦"]
    datas.each do |data|
      books[data]=[]
      books[data][0]=0
      init = $init[:_dhzw]
      init[:book_name] = data
      config = value_replace init, init
      book_search_index_pape config, download do |href, hrefs, config|
        config = value_replace config, {body_href: href}
        book_search_text_all hrefs, config, download do |index, book_name, title, text|
          #section = title.cn_cut_num[0]
          #section = section.cn_to_num if section
          books[book_name][index]=[title,text]
          books[book_name][0] += 1
          str = "#{download.info} #{book_name.truncation 4} #{index} #{books[book_name][0]}/#{hrefs.size} #{title.truncation 8}...\r"
          print str
          if hrefs.size == books[book_name][0]
          	print "\n#{book_name.truncation 4} #{hrefs.size} Finish\n"
            open "./book/#{book_name}.txt",'w' do |file|
              file << book_name << ' ' << books[book_name].join("\n")
              books[book_name] = nil
            end
          end
        end
      end
    end
  end
  download.join
end