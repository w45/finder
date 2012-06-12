require 'spec_helper'

describe Finder::Search do
  let(:word) { 'TEST' }
  let(:values) {%w[test1 test2 test3]}
  let(:file_path) { File.join(Dir.tmpdir, 'tst') }
  let(:index) { 3 }
  let(:finder) { Finder::Search.new(file_path, index) }

  it "should make xml query by word" do
    finder.xml_query(word).to_s.should == "<opt search=\"TEST\" />\n"
  end

  it "should get result from server" do
    items = finder.query(word)
    items.should be_an_instance_of(Array)
    item = items[0]
    item.has_key?('domain').should be_true
    item['domain'].should_not be_nil
  end

  it "should return result witn index = n for query word" do
    items = finder.query(word)
    result = items[index]['domain']
    find_result = finder.find(word)
    find_result.should_not be_nil
    find_result.should == result
  end

  describe 'with file' do
    before :each do
      File.open(file_path, 'w') { |f| values.each { |v| f.puts(v) }}
    end

    it "should read file and return list of values for query" do
      finder.file_values.should == values
    end

    it "should return resultis witn index = n for all words in file" do
      list_of_results = []
      values.each do |word|
        items = finder.query(word)
        list_of_results << items[index]['domain']
      end

      find_results = finder.find_for_file
      find_results.count.should == values.count
      find_results.should == list_of_results
    end
  end
end
