#!/usr/bin/env ruby

CON = [10, 12, 15, -9, 15, 10, 14, -5, 14, -7, -12, -10, -1, -11]
ADJ = [15, 8,  2,  6,  13, 4,  1,  9,  5,  13, 9,   6,   2,  2]

serial = ARGV[0]&.split('')&.map(&:to_i) or fail "Please supply serial"

z = 0

p serial.map.with_index {|w,i| w+ADJ[i]}

serial.each.with_index do |w,i|
  mod = z%26
  if CON[i] < 0
    z /= 26
    if w == mod + CON[i]
      puts "yes"
    else
      z *= 26
      z += w + ADJ[i]
    end
  else
    z *= 26
    z += w + ADJ[i]
  end
end

puts z

# checks++ if d[i] == mod + con[i]
# where mod is d[i]+adj[i] from the last failed check
# passes if checks >= 7

# passes if d3 == d2-7
# passes if d7 == d6-4
# passes if d9 == d8-2
# passes if d10 == d5-8
# passes if d11 == d4+3
# passes if d12 == d1+7
# passes if d13 == d0+4
