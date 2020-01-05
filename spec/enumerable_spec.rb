# frozen_string_literal: true

require './lib/enumerable.rb'

describe '#my_each' do
  it 'return the same array' do
    expect(%w[a b c].my_each { |x| }).to eql(%w[a b c])
  end
end
