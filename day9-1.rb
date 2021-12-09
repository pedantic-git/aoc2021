#!/usr/bin/env ruby

require 'paint'

class Grid
  attr_reader :width, :grid
  
  def initialize(lines)
    @width = lines.first.length
    @grid = lines.flat_map {|l| l.split('').map(&:to_i)}
  end
  
  def low_points
    grid.select.with_index {|_,i| low_point?(i) }
  end
  
  def total_low_points_risk
    lp = low_points
    lp.sum + lp.length
  end
  
  def visual
    "".tap do |out|
      grid.each_index do |i|
        if low_point?(i)
          out << Paint[grid[i], :red, :bright]
        else
          out << Paint[grid[i], [0, grid[i]*25+30, 0]]
        end
        out << "\n" if (i+1)%width==0
      end
    end
  end  
  
  private
  
  # What are the neighbours of index i?
  def neighbours(i)
    [].tap do |n|
      # north
      n << i-width unless i < width
      # east
      n << i+1 unless (i+1)%width == 0
      # south
      n << i+width unless i > (grid.length-width)
      # west
      n << i-1 unless i%width == 0
    end
  end
  
  def low_point?(i)
    neighbours(i).all? {|n| grid[n] > grid[i]}
  end
end

g = Grid.new($stdin.readlines.map(&:chomp))
puts g.visual
puts g.total_low_points_risk
