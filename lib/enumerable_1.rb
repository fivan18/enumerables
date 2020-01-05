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
                  proc do |item, patt|
                    if patt.is_a? Regexp
                      patt.match?(item)
                    else
                      item.is_a? patt
                    end
                  end
                else
                  proc { |item, _patt| item }
                end

    my_each do |item|
      puts condition.call(item, pattern)
      return false unless condition.call(item, pattern)
    end
    true
  end

  def my_any?(pattern = nil)
    condition = if block_given?
                  proc { |item, _patt| yield(item) }
                elsif !pattern.nil?
                  proc do |item, patt|
                    if patt.is_a? Regexp
                      patt.match?(item)
                    else
                      item.is_a? patt
                    end
                  end
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
                  proc do |item, patt|
                    if patt.is_a? Regexp
                      patt.match?(item)
                    else
                      item.is_a? patt
                    end
                  end
                else
                  proc { |item, _patt| item }
                end

    my_each do |item|
      return false if condition.call(item, pattern)
    end
    true
  end
end
