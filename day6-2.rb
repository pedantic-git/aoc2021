#!/usr/bin/env ruby

# Count the number of each fish instead of putting each fish in
# memory, to save on RAM
# def n_fish_starting_from(initial)
#   school = (0..8).to_h {|n| [n,0]}
#   school[initial] = 1
#   256.times do
#     (0..8).each {|n| school[n-1] = school[n]}
#     school[8] = school.delete(-1)
#     school[6] += school[8]
#   end
#   school.values.sum
# end
# 
# TOTALS = (0..6).to_h {|n| [n, n_fish_starting_from(n)]}

TOTALS = {
  0=>6703087164, 
  1=>6206821033, 
  2=>5617089148, 
  3=>5217223242, 
  4=>4726100874, 
  5=>4368232009, 
  6=>3989468462
}

# Now we can just multiply each fish in the initial set by its
# relevant total
puts $stdin.read.split(',').map {|f| TOTALS[f.to_i]}.sum
