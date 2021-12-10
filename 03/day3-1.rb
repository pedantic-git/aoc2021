#!/usr/bin/env ruby

def by_bit(strs)
  split_strs = strs.map {|s| s.split('')}
  split_strs[0].zip *split_strs[1..]
end

def most_common(arr)
  arr.tally.max_by(&:last).first
end

def most_common_bstr(strs)
  by_bit(strs).map(&method(:most_common)).join
end

def rates(strs)
  most_common_bstr(strs).then do |mcb|
    {
      gamma: mcb.to_i(2),
      epsilon: mcb.tr('01', '10').to_i(2)
    }
  end
end

r = rates($stdin.readlines)
puts r[:gamma] * r[:epsilon]
