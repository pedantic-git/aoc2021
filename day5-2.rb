#!/usr/bin/env ruby

require 'pry'

class Ocean
  
  def initialize(max)
    # A max-by-max grid of zeros
    @grid = Array.new(max) { Array.new(max, 0) }
  end
  
  def add_line(x1, y1, x2, y2)
    if x1 == x2
      # Vertical
      between(y1, y2).each {|y| add_vent(x1, y) }
    elsif y1 == y2
      # Horizontal
      between(x1, x2).each {|x| add_vent(x, y1) }
    elsif (x1 > x2) == (y1 > y2)
      # NWSE diagonal
      ystart = y1 > y2 ? y2 : y1
      between(x1, x2).each.with_index {|x,i| add_vent(x, ystart+i)}
    else
      # SWNE diagonal
      ystart = y1 > y2 ? y1 : y2
      between(x1, x2).each.with_index {|x,i| add_vent(x, ystart-i) }
    end
  end
  
  def to_s
    @grid.map {|y| y.map {|x| x == 0 ? "." : x}.join + "\n"}.join
  end
  
  def n_dangers
    @grid.flatten.select {|n| n > 1}.length
  end
  
  private
  
  def add_vent(x, y)
    @grid[y][x] += 1
  end
  
  # Iterator for the range in the correct order regardless
  # of which is bigger of p1/p2
  def between(p1, p2)
    (p1 > p2 ? p2..p1 : p1..p2)
  end
   
end

o = Ocean.new(1000)
$stdin.readlines.each do |line| 
  /(\d+),(\d+) -> (\d+),(\d+)/.match(line)&.captures&.map(&:to_i)&.then {|coords| o.add_line(*coords)}
end

puts o.n_dangers
