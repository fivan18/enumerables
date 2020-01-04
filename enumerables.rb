module Enumerable
    def my_each
        # return an enumerator
        return self.each unless block_given?

        i = 0
        while i < self.size
            yield(self[i])
            i = i + 1
        end
        return self
    end            
    def my_each_with_index
        return self.my_each unless block_given?

        i = 0
        while i < self.size
            yield(self[i], i)
            i = i + 1
        end
        return self
    end
    def my_select
        return self.my_each unless block_given?

        arr = []
        self.my_each do |item|
            arr.push(item) if yield(item)
        end
        return arr
    end
    def my_all?(pattern = nil)
        if block_given?
            condition = Proc.new { |item,pattern| yield(item) }
        elsif !pattern.nil?
            condition = Proc.new { |item,pattern| pattern === item }
        else
            condition = Proc.new { |item,pattern| item }
        end

        self.my_each do |item|
            return false unless condition.call(item,pattern)
        end
        return true
    end
end