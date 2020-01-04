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
    def my_all?
        self.my_each do |item|
            return false unless yield(item)
        end
        true
    end
end