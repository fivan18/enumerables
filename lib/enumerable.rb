# frozen_string_literal: true

module Enumerable
  def my_each
    # return an enumerator
    return each unless block_given?

    i = 0
    while i < size
      yield(self[i])
      i += 1
    end
    self
  end

  def my_each_with_index
    return my_each unless block_given?

    i = 0
    while i < size
      yield(self[i], i)
      i += 1
    end
    self
  end

  def my_select
    return my_each unless block_given?

    arr = []
    my_each do |item|
      arr.push(item) if yield(item)
    end
    arr
  end

  def my_all?(pattern = nil)
    condition = if block_given?
                  proc { |item, _patt| yield(item) }
                elsif !pattern.nil?
                  proc { |item, patt| patt === item }
                else
                  proc { |item, _patt| item }
                end

    my_each do |item|
      return false unless condition.call(item, pattern)
    end
    true
  end

  def my_any?(pattern = nil)
    condition = if block_given?
                  proc { |item, _patt| yield(item) }
                elsif !pattern.nil?
                  proc { |item, patt| patt === item }
                else
                  proc { |item, _patt| item }
                end

    my_each do |item|
      return true if condition.call(item, pattern)
    end
    false
  end

  def my_none?(pattern = nil)
    condition = if block_given?
                  proc { |item, _patt| yield(item) }
                elsif !pattern.nil?
                  proc { |item, patt| patt === item }
                else
                  proc { |item, _patt| item }
                end

    my_each do |item|
      return false if condition.call(item, pattern)
    end
    true
  end

  def my_count(item = nil)
    count = 0
    if block_given?
      my_each { |i| count += 1 if yield(i) }
    elsif !item.nil?
      my_each { |i| count += 1 if i == item }
    else
      return size
    end
    count
  end

  def my_map(proc = nil)
    arr = []
    if proc
      my_each { |i| arr.push(proc.call(i)) }
    elsif block_given?
      my_each { |i| arr.push(yield(i)) }
    else
      return my_each
    end
    arr
  end

  def my_inject(*args)
    initial = nil
    if block_given?
      initial = args.empty? ? self[0] : args[0]
      my_each_with_index do |item, index|
        initial = args.empty? && index.zero? ? initial : yield(initial, item)
      end
    else
      sym = nil
      if args.size == 1
        initial = self[0]
        sym = args[0]
      else
        initial = args[0]
        sym = args[1]
      end
      my_each_with_index do |item, index|
        initial = args.size == 1 && index.zero? ? initial : initial.send(sym, item)
      end
    end
    initial
  end
end

def multiply_els(arr)
  arr.my_inject(1, :*)
end
