module Enumerable
=begin
        my_each

        > a = [ "a", "b", "c" ]
        > a.my_each {|x| print x, " -- " } #=> [ "a", "b", "c" ]
        > a -- b -- c --
=end
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
=begin
        my_each_with_index

        hash = Hash.new
        %w(cat dog wombat).my_each_with_index { |item, index|
            hash[item] = index
        }
        hash   #=> {"cat"=>0, "dog"=>1, "wombat"=>2}
=end
    def my_each_with_index
        return self.my_each unless block_given?

        i = 0
        while i < self.size
            yield(self[i], i)
            i = i + 1
        end
        return self
    end
=begin
        my_select

        (1..10).to_a.my_select { |i|  i % 3 == 0 }   #=> [3, 6, 9]
        [1,2,3,4,5].my_select { |num|  num.even?  }   #=> [2, 4]
        [:foo, :bar].my_select { |x| x == :foo }   #=> [:foo]
=end
    def my_select
        return self.my_each unless block_given?

        arr = []
        self.my_each do |item|
            arr.push(item) if yield(item)
        end
        return arr
    end
=begin
        my_all?

        %w[ant bear cat].my_all? { |word| word.length >= 3 } #=> true
        %w[ant bear cat].my_all? { |word| word.length >= 4 } #=> false
        %w[ant bear cat].my_all?(/t/)                        #=> false
        [1, 2i, 3.14].my_all?(Numeric)                       #=> true
        [nil, true, 99].my_all?                              #=> false
        [].my_all?                                           #=> true
=end
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
=begin
        my_any?

        %w[ant bear cat].my_any? { |word| word.length >= 3 } #=> true
        %w[ant bear cat].my_any? { |word| word.length >= 4 } #=> true
        %w[ant bear cat].my_any?(/d/)                        #=> false
        [nil, true, 99].my_any?(Integer)                     #=> true
        [nil, true, 99].my_any?                              #=> true
        [].my_any?                                           #=> false
=end
    def my_any?(pattern = nil)
        if block_given?
            condition = Proc.new { |item,pattern| yield(item) }
        elsif !pattern.nil?
            condition = Proc.new { |item,pattern| pattern === item }
        else
            condition = Proc.new { |item,pattern| item }
        end

        self.my_each do |item|
            return true if condition.call(item,pattern)
        end
        return false
    end    
end