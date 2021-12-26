#!/usr/bin/env ruby

DIV = [1,  1,  1,  26, 1,  1,  1,  26, 1,  26, 26,  26,  26, 26]
CON = [10, 12, 15, -9, 15, 10, 14, -5, 14, -7, -12, -10, -1, -11]
ADJ = [15, 8,  2,  6,  13, 4,  1,  9,  5,  13, 9,   6,   2,  2]

serial = ARGV[0]&.split('')&.map(&:to_i) or fail "Please supply serial"

z = 0

adjs = serial.map.with_index {|w,i| w+ADJ[i]}

serial.each.with_index do |w,i|
  mod = i == 0 ? 0 : adjs[i - 1]
    
  z /= DIV[i]
  if w != mod + CON[i]
    z *= 26
    z += w + ADJ[i]
  end
end

puts z
