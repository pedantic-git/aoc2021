#!/usr/bin/env ruby

require 'paint'

class Grid
  
  attr_reader :grid, :flashes
  
  def initialize(str)
    @grid = str.map(&:chomp).map {|l| l.split('').map(&:to_i)}
    @flashes = 0
  end
  
  def to_s
    grid.map do |row| 
      row.map do |cell|
        cell == 0 ? Paint[cell, :red, :bright] : Paint[cell, [0,cell*25+30,0]]
      end.join
    end.join("\n")
  end
  
  def increment!
    each_coord do |y,x|
      grid[y][x] += 1
    end
    each_coord do |y,x|
      flash(y,x)
    end
  end
  
  private
  
  def each_coord
    (0..9).each {|y| (0..9).each {|x| yield y,x}}
  end
  
  def neighbours(y,x)
    [y-1, y, y+1].product([x-1, x, x+1]).reject do |ny,nx| 
      # we are not our own neighbour
      (ny==y && nx==x) ||
      !(0..9).include?(ny) ||
      !(0..9).include?(nx)
    end
  end
  
  def flash(y,x)
    return unless grid[y][x] > 9
    grid[y][x] = 0
    @flashes += 1
    neighbours(y,x).each do |y,x| 
      grid[y][x] +=1 unless grid[y][x] == 0
      flash(y,x)
    end
  end
end

g = Grid.new($stdin.readlines)
100.times { g.increment! }
puts g
puts g.flashes
