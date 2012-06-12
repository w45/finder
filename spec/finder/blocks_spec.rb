require 'spec_helper'

describe Finder::Queue do
  it "should initialize self with Block" do
    count = 10
    blocks = Finder::Queue.new(count)
    blocks.count.should == count
    blocks.each do |b|
      b.should be_an_instance_of(Finder::Queue::QueueValue)
      b.status.should == :new
      b.value.should be_nil
    end
  end

  it "should set value for block with index" do
    blocks = Finder::Queue.new(100)
    blocks.set_value(3, 'TEST')
    block = blocks[3]
    block.value.should == 'TEST'
    block.status.should == :value
  end

  it "should print_value for block with index == 0" do
    index = 0
    blocks = Finder::Queue.new(100)
    blocks.set_value(index, 'TEST')
    blocks.print_value(index).should be_true
    blocks[index].status.should == :printed
  end

  it "should print_value for block with index > 0 if previous blocks are printed" do
    index = 5
    blocks = Finder::Queue.new(100)
    (0..4).each do |i|
      blocks[i].status = :printed
    end
    blocks.set_value(index, 'TEST')
    blocks.print_value(index).should be_true
    blocks[index].status.should == :printed
  end
  
  it "should print_value for blocks with index >= index if they has values" do
    index = 0
    blocks = Finder::Queue.new(100)
    (0..4).each do |i|
      blocks[i].status = :value
      blocks[i].value = 'TEST'
    end
    blocks.print_value(index).should be_true
    (0..4).each do |i|
      blocks[i].status.should == :printed
    end
  end
end
