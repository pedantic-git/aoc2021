#!/usr/bin/env ruby

puts $stdin.readlines.map(&:to_i).each_cons(2).map {|l,r| l<=>r}.count(-1)
