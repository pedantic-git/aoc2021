#!/usr/bin/env ruby

class Caves
  attr_reader :map, :paths
  
  def initialize(map)
    @map = {}
    map.each do |line|
      /(\w+)\-(\w+)/.match(line)
      @map[$1] ||= []
      @map[$1] << $2
      @map[$2] ||= []
      @map[$2] << $1
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
    # Can't go back to a lowercase we've already seen
    exclude = path.grep /[a-z]/
    map[path.last] - exclude
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
