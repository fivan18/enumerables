# frozen_string_literal: true

require './lib/enumerable.rb'

describe '#my_each' do
  it 'return the same array' do
    expect(%w[a b c].my_each { |x| }).to eql(%w[a b c])
  end
end

describe '#my_select' do
  it 'numbers divisible by 3' do
    expect((1..10).to_a.my_select { |i| i % 3 == 0 }).to eql([3, 6, 9])
  end
  it 'even numbers' do
    expect([1, 2, 3, 4, 5].my_select(&:even?)).to eql([2, 4])
  end
  it 'symbols :foo' do
    expect(%i[foo bar].my_select { |x| x == :foo }).to eql([:foo])
  end
end

describe '#my_all?' do
  it 'all strings with length >= 3' do
    expect(%w[ant bear cat].my_all? { |word| word.length >= 3 }).to eql(true)
  end
  it 'all strings with length >= 4' do
    expect(%w[ant bear cat].my_all? { |word| word.length >= 4 }).to eql(false)
  end
  it 'all match with the pattern /t/' do
    expect(%w[ant bear cat].my_all?(/t/)).to eql(false)
  end
  it 'all are Numeric' do
    expect([1, 2i, 3.14].my_all?(Numeric)).to eql(true)
  end
  it 'all are truthy values' do
    expect([nil, true, 99].my_all?).to eql(false)
  end
  it 'an empty array return true' do
    expect([].my_all?).to eql(true)
  end
end
