module Finder
  class Queue < Array
    class QueueValue
      attr_accessor :value, :status
      def initialize
        @status = :new
        @value = nil
      end
    end
  
    def initialize(count)
      super(count)
      count.times { |index| self[index] = QueueValue.new }
    end

    def print_value(index)
      return false if @busy == true
      work_index = index
      while work_index < self.count && (work_index == 0 || self[work_index - 1].status == :printed) && (block = self[work_index]).status == :value
        puts block.value
        block.status = :printed
        work_index += 1
      end
      @busy = false
      true
    end

    def set_value(index, value)
      block = self[index]
      block.value = value
      block.status = :value
    end
  end
end
