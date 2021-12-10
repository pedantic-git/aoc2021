#!/usr/bin/env ruby

def by_bit(strs)
  split_strs = strs.map {|s| s.split('')}
  split_strs[0].zip *split_strs[1..]
end

# Can't use max_by / min_by because of the "or equal" rule
def most_common(arr)
  arr.tally.then {|tal| tal.fetch("1", 0) >= tal.fetch("0", 0) ? "1" : "0" }
end

def least_common(arr)
  arr.tally.then {|tal| tal.fetch("0", 0) <= tal.fetch("1", 0) ? "0" : "1"}
end

# Filter to only those values that contain the bit that is the most or least
# common in that position (which is determined by the bool second param)
def filter_by_position(strs, pos, most)
  bb = by_bit(strs)
  bit = most ? most_common(bb[pos]) : least_common(bb[pos])
  strs.select {|s| s[pos] == bit }
end

strs_o2 = $stdin.readlines
strs_co2 = strs_o2.dup
pos = 0
while strs_o2.length > 1
  strs_o2 = filter_by_position(strs_o2, pos, true)
  pos += 1
end
pos = 0
while strs_co2.length > 1
  strs_co2 = filter_by_position(strs_co2, pos, false)
  pos += 1
end

puts strs_o2.first.to_i(2) * strs_co2.first.to_i(2)
