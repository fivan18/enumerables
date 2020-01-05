# frozen_string_literal: true

module Enumerable
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
    values = get_initial_symbol(args)
    initial = values[0]
    sym = values[1]

    if block_given?
      my_each_with_index do |item, index|
        initial = args.empty? && index.zero? ? initial : yield(initial, item)
      end
    else
      my_each_with_index do |item, index|
        initial = args.size == 1 && index.zero? ? initial : initial.send(sym, item)
      end
    end
    initial
  end

  def get_initial_symbol(args)
    initial = nil
    symbol = nil
    case args.size
    when 0
      initial = self[0]
      symbol = nil
    when 1
      if args[0].is_a? Symbol
        initial = self[0]
        symbol = args[0]
      else
        initial = args[0]
        symbol = nil
      end
    when 2
      initial = args[0]
      symbol = args[1]
    end
    [initial, symbol]
  end
end
