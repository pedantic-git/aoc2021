#!/usr/bin/env ruby

w = ARGV[0]&.split('')&.map(&:to_i) or fail "Please supply serial"

if (w[3]  == w[2]-7) && 
   (w[7]  == w[6]-4) && 
   (w[9]  == w[8]-2) && 
   (w[10] == w[5]-8) &&
   (w[11] == w[4]+3) &&
   (w[12] == w[1]+7) &&
   (w[13] == w[0]+4)
  puts "PASS"
else
  puts "FAIL"
end
