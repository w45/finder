require 'rest_client'
require 'xmlsimple'
require File.expand_path(File.join(File.dirname(__FILE__), 'queue.rb'))

module Finder
  class Search
    def initialize(file_path, index, opts = {})
      @file_path = file_path
      @index = index
      @host = opts[:host] || 'localhost:4567'
      @mutex = Mutex.new
      @threads_count = opts[:threads_count] || 100
    end

    def query(word)
      results = XmlSimple.xml_in(RestClient.post("http://#{host}/query", :query => xml_query(word)))
      results['result']
    end

    def xml_query(word)
      XmlSimple.xml_out({:search => word})
    end

    def file_values
      return nil unless File.exists?(@file_path)
      values = nil 
      File.open(@file_path, 'r') { |f| values = f.readlines }
      values.map { |v| v.strip }
    end

    def find(word)
      items = query(word)
      return nil if items.count < @index
      items[@index]['domain']
    end

    def find_for_file
      list_of_values = file_values
      return unless list_of_values
      list_of_results = []
      list_of_values.each { |value| list_of_results << find(value) }
      list_of_results
    end

    def print_finds
      @counter = -1
      @list_of_values = file_values
      return unless @list_of_values
      blocks = Finder::Queue.new(@list_of_values.count)
      threads = []
      @threads_count.times do 
        threads << Thread.new do |index|
          while index = counter
            word = @list_of_values[index]
            result = find(word)
            blocks.set_value(index, result)
            blocks.print_value(index)
          end
        end
      end
      threads.each { |th| th.join }
    end
    
    def counter
      @mutex.lock
      @counter += 1
      result = @counter < @list_of_values.count ? @counter : nil
      @mutex.unlock
      result
    end
  end
end