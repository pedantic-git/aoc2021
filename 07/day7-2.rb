#!/usr/bin/env ruby


def triangle(n)
  n * (n+1) / 2
end

def fuel(crabs, pos)
  crabs.map {|c| triangle((pos-c).abs)}.sum
end

crabs = $stdin.read.split(',').map(&:to_i).sort
crabs_fuel = (0..crabs.max).map {|pos| fuel(crabs, pos)}

puts crabs_fuel.min
