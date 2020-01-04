module Enumerable
    def my_each
        i = 0
        while i < self.size
            yield(self[i])
            i = i + 1
        end
    end            
    def my_each_with_index
        i = 0
        while i < self.size
            yield(self[i], i)
            i = i + 1
        end
    end
    def my_select
        return_arr = []
        self.my_each do |item|
            return_arr.push(item) if yield(item)
        end
        return_arr
    end
end