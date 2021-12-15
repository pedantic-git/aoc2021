#!/usr/bin/env ruby

class Polymer
  
  attr_reader :tallies, :rules, :final
  
  def initialize(start, rules)
    @tallies = tally_string(start)
    @final = start[-1]
    @rules = rules
  end
  
  def step!
    # Change the counts for each pair, working on a duplicate so
    # our changes don't affect the results
    tallies.dup.each do |pair, n|
      # remove n from the tallies for this pair
      tallies[pair] -= n
      # add n to each of the resulting pairs after the insertion
      tallies[pair[0] + rules[pair]] += n
      tallies[rules[pair] + pair[1]] += n
    end
  end
  
  def tally_letters
    # Tally the first half of each pair and add 1 for the final letter
    # that never got to take part in this charade
    tallies.inject(Hash.new {0}) do |acc, kv|
      pair, n = *kv
      acc.tap {|acc| acc[pair[0]] += n }
    end.tap do |acc|
      acc[final] += 1
    end
  end
  
  def most_to_least_diff
    tally_letters.then {|tal| tal.values.max - tal.values.min}
  end
  
  private
  
  def tally_string(str)
    str.split('').each_cons(2).inject(Hash.new {0}) do |tallies, cons|
      tallies[cons.join] += 1
      tallies
    end
  end
  
end

start = $stdin.readline.chomp
$stdin.readline # blank line
rules = $stdin.readlines.inject({}) do |rules, line|
  /(\w\w) -> (\w)/.match(line)
  rules[$1] = $2
  rules
end

poly = Polymer.new(start, rules)
40.times { poly.step! }
p poly.most_to_least_diff
