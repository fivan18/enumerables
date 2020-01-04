module Enumerable
    def my_each_with_index
        i = 0
        while i < self.size
            yield(self[i], i)
            i = i + 1
        end
    end
end