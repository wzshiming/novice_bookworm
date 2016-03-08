#!/usr/bin/env ruby2.0
require 'mongo'  

class Database
  attr_accessor :base
  def initialize opts = {host: 'localhost',port: 27017,database: 'local'}
    @base = Mongo::Connection.new(opts[:host], opts[:port]).db opts[:database]
    @base.authenticate opts[:username], opts[:password]
    @base
  end
  
  def new_data optsbase, opts
    #opts['self_create_time']=Time.now
    opts['self_base_name']=optsbase
    @base[optsbase].insert opts
  end
  

  def update querybase, query, opts
    @base[querybase].update query, opts
  end
  
  def update_data opt, querybase, query, opts
    @base[querybase].update query, opt => opts
  end
  
  def edit_data querybase, query, opts
    update_data '$set', querybase, query, opts
  end
  
  def free_data querybase, query, opts
    update_data '$unset', querybase, query, opts
  end
  
  def add_array querybase, query, opts
    update_data '$push',querybase, query, opts
  end
  
  def sub_array querybase, query, opts
    update_data '$pull',querybase, query, opts
  end
  
  def info_count querybase, query, name, size=1, suf='Count'
    update_data '$inc', querybase, query, name+suf => size
  end
    
  def info_time querybase, query, name, suf='Update'
    edit_data querybase, query, name+suf => Time.now
  end

  def opts_check opts, dels=[]
    dels+=['_id']
    dels.each do |n| 
      opts.delete n.to_sym
      opts.delete n.to_s
    end
    opts.size != 0
  end

  def find_one querybase, query={}
    @base[querybase].find_one query
  end
  
  def find querybase, query={}
    @base[querybase].find query
  end

  def free_pointAll querybase, query, pointname
    return nil unless obj=find_one(querybase, query)
    (obj[pointname+'Point_array']||[]).each { |n| remove_data pointname, _id: n}
    edit_data querybase, query, pointname+'Point_array' => []
  end
  
  def free_point querybase, query, pointname, pointquery
    return nil unless obj=find_one(querybase, query)
    return nil unless e=obj[pointname+'Point_array'].find(id) 
    remove_data pointname, _id: id
    sub_array querybase, query, pointname+'Point_array' => pointquery
  end

  def add_point querybase, query, pointbase, pointquery
    return nil unless obj=find_one(pointbase, pointquery)
    add_array querybase, query, pointbase+'Point_array' => obj['_id']
  end

  def sub_point querybase, query, pointbase, pointquery
    return nil unless obj=find_one(pointbase, pointquery)
    sub_array querybase, query, pointbase+'Point_array' => obj['_id']
  end
  
  def add_info querybase, query, infos, name='none'
    add_array querybase, query, name+'Info_array' => infos
  end
  
  def sub_info querybase, query, infos, name='none'
    sub_array querybase, query, name+'Info_array' => infos
  end
 
  def remove_data querybase, query={}
    @base[querybase].remove query
  end
  
  def print_all querybase, query={}
    arr=[]
    find(querybase,query).each { |data| arr<< data }
    puts arr
  end
 
end

__END__
