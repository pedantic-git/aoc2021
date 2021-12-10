#!/usr/bin/ruby

PAIRS = {
  '(' => ')',
  '[' => ']',
  '{' => '}',
  '<' => '>'
}
IPAIRS = PAIRS.invert

VALUES = {
  ')' => 1,
  ']' => 2,
  '}' => 3,
  '>' => 4
}

# Get the completion string (as an array) for the given line or []
# if complete or corrupted
def completion_for(line)
  stack = []
  line.chomp.each_char do |c|
    if PAIRS.keys.include? c
      stack.unshift c
    elsif stack.shift != IPAIRS[c]
      # Corrupted - discard
      return []
    end
  end
  stack.map {|c| PAIRS[c]}
end

# Score the given completion string (array)
def score_completion(completion)
  completion.inject(0) {|acc, c| acc*5+VALUES[c]}
end

lines = $stdin.readlines.map {|l| score_completion(completion_for l)}.reject(&:zero?)
puts lines.sort[lines.length / 2]
