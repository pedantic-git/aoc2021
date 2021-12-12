#!/usr/bin/env ruby

class Caves
  attr_reader :map, :paths
  
  def initialize(map)
    @map = {}
    map.each do |line|
      /(\w+)\-(\w+)/.match(line)
      @map[$1] ||= []
      @map[$1] << $2 unless $2 == 'start' || $1 == 'end'
      @map[$2] ||= []
      @map[$2] << $1 unless $1 == 'start' || $2 == 'end'
    end
    # Start with one path that begins at 'start'
    @paths = [['start']]
  end
  
  def run!
    step! until paths.all? {|p| p.last == 'done'}
    # Drop the 'done' off the end
    paths.each(&:pop)
    # Remove paths that didn't reach the end
    paths.select! {|path| path.last == 'end'}
  end
  
  private
  
  def possible_steps_for(path)
    return [] if path.last == 'end'
    # Can't go back to 'start' or to a lowercase cave if there
    # are already two of the same lowercase cave
    lowercases = path.grep /[a-z]/
    if lowercases.tally.any? {|_,t| t >= 2}
      map[path.last] - lowercases
    else
      map[path.last]
    end
  end
  
  def step!
    # work on a copy so we don't end up iterating our modifications
    paths.reject {|path| path.last == 'done'}.each do |path|
      possibilities = possible_steps_for(path)
      if possibilities.empty?
        path << 'done'
        next
      end
      # If there's more than one possibility, add them to the paths
      possibilities[1..].each do |fork|
        paths << path+[fork]
      end
      # And add the first possibility to the original path
      path << possibilities.first
    end
  end
end

c = Caves.new($stdin.readlines)
c.run!
p c.paths.length
