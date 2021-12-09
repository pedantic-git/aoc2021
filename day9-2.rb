#!/usr/bin/env ruby

class Grid
  attr_reader :width, :grid
  
  def initialize(lines)
    @width = lines.first.length
    @grid = lines.flat_map {|l| l.split('').map(&:to_i)}
  end
  
  def low_point_indexes
    grid.each_index.select {|i| low_point?(i) }
  end
  
  def basins
    low_point_indexes.map {|i| basin(i)}
  end
  
  def basin_sizes
    basins.map(&:length)
  end
  
  def product_of_three_largest_basins
    basin_sizes.sort.last(3).reduce(&:*)
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
      n << i+width unless i >= (grid.length-width)
      # west
      n << i-1 unless i%width == 0
    end
  end
  
  def low_point?(i)
    neighbours(i).all? {|n| grid[n] > grid[i]}
  end
  
  # Give it a point, it will give you all the indexes in its basin
  def basin(i, seen=[])
    return [] if grid[i] == 9
    seen += [i]
    neighbours(i).each do |n|
      next if seen.include? n
      seen |= basin(n, seen)
    end
    seen
  end
end

g = Grid.new($stdin.readlines.map(&:chomp))
puts g.product_of_three_largest_basins
