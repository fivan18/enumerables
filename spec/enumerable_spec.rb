# frozen_string_literal: true

require './lib/enumerable_1.rb'
require './lib/enumerable_2.rb'
require './lib/multiply_els.rb'

describe '#my_each' do
  before(:each) do
    @arr = []
    %w[a b c].my_each { |x| @arr.push(x) }
  end
  it 'fill an array with another array values' do
    expect(@arr).to eql(%w[a b c])
  end
end

describe '#my_each_with_index' do
  before(:each) do
    @hash = {}
    %w[cat dog wombat].my_each_with_index do |item, index|
      @hash[item] = index
    end
  end
  it 'fill a hash with array values' do
    expect(@hash).to eql('cat' => 0, 'dog' => 1, 'wombat' => 2)
  end
end

describe '#my_select' do
  it 'numbers divisible by 3' do
    expect((1..10).to_a.my_select { |i| i % 3 == 0 }).to eql([3, 6, 9])
  end
  it 'even numbers' do
    expect([1, 2, 3, 4, 5].my_select(&:even?)).to eql([2, 4])
  end
  it ':foo symbols' do
    expect(%i[foo bar].my_select { |x| x == :foo }).to eql([:foo])
  end
end

describe '#my_all?' do
  it 'all strings with length >= 3?' do
    expect(%w[ant bear cat].my_all? { |word| word.length >= 3 }).to eql(true)
  end
  it 'all strings with length >= 4?' do
    expect(%w[ant bear cat].my_all? { |word| word.length >= 4 }).to eql(false)
  end
  it 'all the strings match with the pattern /t/?' do
    expect(%w[ant bear cat].my_all?(/t/)).to eql(false)
  end
  it 'all values are Numeric?' do
    expect([1, 2i, 3.14].my_all?(Numeric)).to eql(true)
  end
  it 'all are truthy values?' do
    expect([nil, true, 99].my_all?).to eql(false)
  end
  it 'no values' do
    expect([].my_all?).to eql(true)
  end

  describe '#my_any?' do
    it 'any string with length >= 3?' do
      expect(%w[ant bear cat].my_any? { |word| word.length >= 3 }).to eql(true)
    end
    it 'any string with length >= 4?' do
      expect(%w[ant bear cat].my_any? { |word| word.length >= 4 }).to eql(true)
    end
    it 'any string match with the pattern /d/?' do
      expect(%w[ant bear cat].my_any?(/d/)).to eql(false)
    end
    it 'any value is Integer?' do
      expect([nil, true, 99].my_any?(Integer)).to eql(true)
    end
    it 'any of the values is a truthy value?' do
      expect([nil, true, 99].my_any?).to eql(true)
    end
    it 'no values' do
      expect([].my_any?).to eql(false)
    end
  end

  describe '#my_none?' do
    it 'no one have a length = 5?' do
      expect(%w[ant bear cat].my_none? { |word| word.length == 5 }).to eql(true)
    end
    it 'no one have a length >= 4?' do
      expect(%w[ant bear cat].my_none? { |word| word.length >= 4 }).to eql(false)
    end
    it 'no one match with the pattern /d/?' do
      expect(%w[ant bear cat].my_none?(/d/)).to eql(true)
    end
    it 'no one is Float?' do
      expect([1, 3.14, 42].my_none?(Float)).to eql(false)
    end
    it 'no values' do
      expect([].my_none?).to eql(true)
    end
    it 'an array with no truthy values' do
      expect([nil].my_none?).to eql(true)
    end
    it 'an array with no truthy values' do
      expect([nil, false].my_none?).to eql(true)
    end
    it 'an array with a truthy value' do
      expect([nil, false, true].my_none?).to eql(false)
    end
  end

  describe '#my_count' do
    it 'no block and no parameter' do
      expect([1, 2, 4, 2].my_count).to eql(4)
    end
    it 'only parameter' do
      expect([1, 2, 4, 2].my_count(2)).to eql(2)
    end
    it 'only block' do
      expect([1, 2, 4, 2].my_count(&:even?)).to eql(3)
    end
  end

  describe '#my_map' do
    it 'using proc' do
      expect((1..4).to_a.my_map(proc { |i| i * i })).to eql([1, 4, 9, 16])
    end
    it 'using proc' do
      expect((1..4).to_a.my_map(proc { 'cat' })).to eql(%w[cat cat cat cat])
    end
    it 'using block' do
      expect((1..4).to_a.my_map { |i| i * i }).to eql([1, 4, 9, 16])
    end
    it 'using block' do
      expect((1..4).to_a.my_map { 'cat' }).to eql(%w[cat cat cat cat])
    end
  end

  describe '#my_inject' do
    before(:each) do
      @longest = %w[cat sheep bear].my_inject do |memo, word|
        memo.length > word.length ? memo : word
      end
    end
    it 'sum some numbers using only a symbol' do
      expect((5..10).my_inject(:+)).to eql(45)
    end
    it 'same using only a block' do
      expect((5..10).my_inject { |sum, n| sum + n }).to eql(45)
    end
    it 'multiply some numbers using initial and symbol' do
      expect((5..10).my_inject(1, :*)).to eql(151_200)
    end
    it 'same using initial and block' do
      expect((5..10).my_inject(1) { |product, n| product * n }).to eql(151_200)
    end
    it 'find the longest word' do
      expect(@longest).to eql('sheep')
    end
  end

  describe 'multiply_els' do
    it 'multiply all items' do
      expect(multiply_els([2, 4, 5])).to eql(40)
    end
  end
end
