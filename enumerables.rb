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
=begin
        my_none?

        %w{ant bear cat}.my_none? { |word| word.length == 5 } #=> true
        %w{ant bear cat}.my_none? { |word| word.length >= 4 } #=> false
        %w{ant bear cat}.my_none?(/d/)                        #=> true
        [1, 3.14, 42].my_none?(Float)                         #=> false
        [].my_none?                                           #=> true
        [nil].my_none?                                        #=> true
        [nil, false].my_none?                                 #=> true
        [nil, false, true].my_none?                           #=> false
=end
    def my_none?(pattern = nil)
        if block_given?
            condition = Proc.new { |item,pattern| yield(item) }
        elsif !pattern.nil?
            condition = Proc.new { |item,pattern| pattern === item }
        else
            condition = Proc.new { |item,pattern| item }
        end

        self.my_each do |item|
            return false if condition.call(item,pattern)
        end
        return true
    end  
=begin
        my_count

        ary = [1, 2, 4, 2]
        ary.my_count               #=> 4
        ary.my_count(2)            #=> 2
        ary.my_count{ |x| x%2==0 } #=> 3
=end
    def my_count(item = nil)
        count = 0;
        if block_given?
            self.my_each { |i| count += 1 if yield(i) }
        elsif !item.nil?
            self.my_each { |i| count += 1 if i == item }
        else
            return self.size
        end
        return count
    end                  
=begin
        my_map

        (1..4).to_a.my_map { |i| i*i }      #=> [1, 4, 9, 16]
        (1..4).to_a.my_map { "cat"  }   #=> ["cat", "cat", "cat", "cat"]
=end
    def my_map
        arr = []
        if block_given?
            self.my_each { |i| arr.push(yield(i)) }
            return  arr
        else
            return self.my_each
        end
    end     
=begin
        my_inject

        # Sum some numbers
        (5..10).to_a.my_inject(:+)                             #=> 45
        # Same using a block and inject
        (5..10).to_a.my_inject { |sum, n| sum + n }            #=> 45
        # Multiply some numbers
        (5..10).to_a.my_inject(1, :*)                          #=> 151200
        # Same using a block
        (5..10).to_a.my_inject(1) { |product, n| product * n } #=> 151200
        # find the longest word
        longest = %w{ cat sheep bear }.my_inject do |memo, word|
            memo.length > word.length ? memo : word
        end
        longest                                        #=> "sheep"
=end
    def my_inject(*args)
        set_initial = nil
        initial = nil
        sym = nil
        if args.size == 0
            set_initial = self.size > 0 ? self[0] : 0 
        elsif (args.size == 1) && (args[0].is_a? Symbol)
            set_initial = self.size > 0 ? self[0] : 0
            sym = args[0]
        elsif args.size == 1
            initial = args[0]
        else
            initial = args[0]
            sym = args[1]
        end

        if (initial && block_given?)
            self.my_each { |item| initial = yield(initial, item) }
        elsif block_given?
            self.my_each_with_index { |item,index| set_initial = yield(set_initial, item) if index > 0 }
            return set_initial
        elsif (initial && sym)
            self.my_each { |item| initial = initial.send sym,item }
        elsif sym
            self.my_each_with_index { |item, index| set_initial = set_initial.send sym,item if index > 0 }
            return set_initial
        end
        return initial
    end                  
end