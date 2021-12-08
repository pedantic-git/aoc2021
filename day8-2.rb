#!/usr/bin/env ruby

# Inputs is "acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab"
def get_digits(inputs)
  sorted = inputs.split.map {|i| i.split('').sort}.sort_by {|a| a.length}
  {}.tap do |digits|
    digits[1] = sorted[0]
    digits[7] = sorted[1]
    digits[4] = sorted[2]
    digits[8] = sorted[9]
    # 6 is the only 6-segment number that doesn't contain the segments of 1
    digits[6] = sorted.find {|s| s.length == 6 && (s - digits[1]).length == 5 }
    # 9 is the only 6-segment number that fully contains the segments of 4
    digits[9] = sorted.find {|s| s.length == 6 && (s - digits[4]).length == 2 }
    
    # the missing segment from 6 is the top segment of 1
    top_of_1 = (%w{a b c d e f g} - digits[6]).first
    # and so the other is the bottom
    bottom_of_1 = (digits[1] - [top_of_1]).first
    
    # now we know what the 3 5-segment numbers are
    digits[5] = sorted.find {|s| s.length == 5 && !s.include?(top_of_1)}
    digits[2] = sorted.find {|s| s.length == 5 && !s.include?(bottom_of_1)}
    digits[3] = sorted.find {|s| s.length == 5 && s != digits[2] && s != digits[5]}
  
    # all that's left is 0
    digits[0] = (sorted - digits.values).first
  end.invert
end

def get_value(digits, outputs)
  outputs.split.map {|o| o.split('').sort}.map {|segs| digits[segs].to_s}.join.to_i
end

def solve(line)
  %r{(.*) \| (.*)}.match(line).captures.then do |inputs, outputs|
    digits = get_digits(inputs)
    get_value(digits, outputs)
  end
end

puts $stdin.readlines.map {|l| solve(l)}.sum
