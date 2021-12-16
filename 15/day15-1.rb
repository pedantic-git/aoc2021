#!/usr/bin/env ruby

require 'set'
require 'pry'

# Base this on Dijkstra's algorithm

class Chitons
  
  attr_reader :grid, :q, :dist, :prev, :target
  
  def initialize(lines)
    @grid = lines.map {|l| l.chomp.split('').map(&:to_i)}
    # Add all points to @unvisited
    @q = Set.new
    @grid.each_index {|y| @grid[y].each_index {|x| @q << [x,y]}}
    @dist = @q.inject({}) {|h, v| h[v] = Float::INFINITY; h}
    @dist[[0,0]] = 0
    @prev = {}
    @target = [@grid.first.length - 1, @grid.length - 1]
  end
  
  # Keep running Dijkstra's algorithm until we have filled prev[target]
  def calc!
    until prev.key?(target) do
      best_guess = next_best_guess
      break if best_guess.nil?
      q.delete(best_guess)
      puts q.length
      neighbours_of(best_guess).each do |neighbour|
        next unless q.include? neighbour
        alt = dist[best_guess] + grid[neighbour[1]][neighbour[0]]
        if alt < dist[neighbour]
          dist[neighbour] = alt
          prev[neighbour] = best_guess
        end
      end
    end
  end
  
  # Get the shortest distance to target
  def distance_to_target
    dist[target]
  end
  
  private
  
  # Get the entry in q with the minimum dist
  def next_best_guess
    q.min_by {|v| dist[v]}
  end
  
  # Get the 4 neighbours of a given pair of coords
  def neighbours_of(vertex)
    x, y = *vertex
    [
      [x+1, y],
      [x, y+1],
      [x-1, y],
      [x, y-1],
    ]
  end
  
end

c = Chitons.new($stdin.readlines)
c.calc!
puts c.distance_to_target
