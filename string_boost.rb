#!/usr/bin/env ruby
#-*- coding:utf-8 -*- 
class String
  @@Encodes = %w(gbk gb18030 gb2312 cp936 ucs-bom shift-jis ascii-8bit)
#   @@Encodes = Encoding.list
  def to_utf8!
    @@Encodes.each do |coding|
      begin
        self.force_encoding Encoding::UTF_8
        return self if self.valid_encoding?
        self.encode! Encoding::UTF_8, coding
      rescue
      end
    end
    self
  end
  def truncation size, suf='...'
    return "#{self[0,size]}#{suf}" if self.size > size + 1
    self
  end
end


