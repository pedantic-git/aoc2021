#!/usr/bin/env ruby

# Just calculate each of the 7 possible fish first. Number of
# generations is small enough to use a naive algorithm - not so in
# part 2!

# def n_fish_starting_from(initial)
#   school = [initial]
#   80.times do
#     school.each_index do |i| 
#       school[i] -= 1
#       if school[i] < 0
#         school[i] = 6
#         school << 9
#       end
#     end
#   end
#   school.length
# end
# 
# TOTALS = (0..6).to_h {|n| [n, n_fish_starting_from(n)]}

TOTALS = {
  0=>1421, 
  1=>1401, 
  2=>1191, 
  3=>1154, 
  4=>1034, 
  5=>950, 
  6=>905
}

# Now we can just multiply each fish in the initial set by its
# relevant total
puts $stdin.read.split(',').map {|f| TOTALS[f.to_i]}.sum
