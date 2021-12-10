#!/usr/bin/ruby

PAIRS = {
  ')' => '(',
  ']' => '[',
  '}' => '{',
  '>' => '<'
}

VALUES = {
  ')' => 3,
  ']' => 57,
  '}' => 1197,
  '>' => 25137,
}

# return 0 for success or the bad character value for syntax error
def parse_line(line)
  stack = []
  line.chomp.each_char do |c|
    if PAIRS.values.include? c
      stack.unshift c
    elsif stack.shift != PAIRS[c]
      return VALUES[c]
    end
  end
  0
end

puts $stdin.readlines.map(&method(:parse_line)).sum
