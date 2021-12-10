#!/usr/bin/env ruby

# It's a hunch but I think the median is the shortest distance
crabs = $stdin.read.split(',').map(&:to_i).sort
median_crab = crabs[crabs.length / 2]
puts crabs.map {|c| (median_crab-c).abs}.sum
