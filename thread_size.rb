#!/usr/bin/env ruby 
#-*- coding:utf-8 -*- 
require 'monitor'
class Thread_size
  attr :thread_sum,true
  attr :run_size
  attr :queue
  attr :sum

  @@sleep = 1
  def initialize thread_sum
    @sleep = 0.1
    @sum = 0
    @thread_sum = thread_sum
    @run_size = 0
    @lock = Monitor.new
    @queue = []
    start
  end
  
  def run?
    @run
  end
  
  def forks
    while @run and @queue.size != 0
      @lock.synchronize do
        sleep @sleep while @run_size >= @thread_sum
        @run_size += 1
        Thread.new @queue.shift do |block|
          block.call
          @run_size -= 1
        end
      end
    end
  end
  
  def start
    @run = true
    forks if @run_size <= 1
  end
  
  def stop
    @run = false
  end
  
  def add &block
    @sum += 1
    @queue << block
    forks if @queue.size == 1
  end
  
  def info
    "#{@run_size}/#{@thread_sum} Thread  #{@sum - @queue.size - @run_size}/#{@sum} Size"
  end
  
  def join
    sleep @@sleep while @run_size != 0
  end
end

if __FILE__ == $0
  ts = Thread_size.new 4
  100.times do |i|
    ts.add do
      puts i
    end
  end
  ts.join
end