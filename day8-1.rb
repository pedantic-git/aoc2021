#!/usr/bin/env ruby

puts $stdin.readlines.flat_map {|l| %r{\| (.*)}.match(l)[1].split}.select {|code| [2,3,4,7].include? code.length}.size
