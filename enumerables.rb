module Enumerable
    def my_select
        return_arr = []
        self.my_each do |item|
            return_arr.push(item) if yield(item)
        end
        return_arr
    end
end