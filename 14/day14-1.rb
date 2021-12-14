#!/usr/bin/env ruby

class Polymer
  
  attr_reader :chain, :rules
  
  def initialize(start, rules)
    @chain = start
    @rules = rules
  end
  
  def step!
    @chain = chain.each_cons(2).map do |cons|
      cons.insert(1, rules[cons]) if rules[cons]
      cons.pop # remove the last element so we can join back up
      cons
    end.flatten + [chain.last]
  end
  
  def most_to_least_diff
    chain.tally.then {|tal| tal.values.max - tal.values.min}
  end
end

start = $stdin.readline.chomp.split('')
$stdin.readline # blank line
rules = $stdin.readlines.inject({}) do |rules, line|
  /(\w)(\w) -> (\w)/.match(line)
  rules[[$1,$2]] = $3
  rules
end

poly = Polymer.new(start, rules)
10.times { poly.step! }
p poly.most_to_least_diff
