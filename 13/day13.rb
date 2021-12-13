#!/usr/bin/env ruby

class Paper
  attr_reader :dots
  
  def initialize(points)
    width = points.map(&:first).max + 1
    height = points.map(&:last).max + 1
    @dots = Array.new(height) { Array.new(width,false) }
    points.each do |x,y|
      @dots[y][x] = true
    end
  end
  
  def to_s
    dots.map {|r| r.map {|c| c ? "#":" "}.join}.join("\n")
  end
  
  def run!(instructions)
    instructions.each do |i|
      case i
      when /fold along x=(\d+)/
        fold_x($1.to_i)
      when /fold along y=(\d+)/
        fold_y($1.to_i)
      end
    end
  end
  
  def n_visible
    @dots.flatten.select(&:itself).length
  end
  
  private
  
  def fold_x(coord)
    dots.map! do |row|
      l, r = row[0..coord-1], row[coord+1..-1].reverse
      # Pad them to the same size
      if l.length > r.length
        r = Array.new(l.length-r.length, false) + r
      elsif r.length > l.length
        l = Array.new(r.length-l.length, false) + l
      end
      l.zip(r).map {|c1,c2| c1 | c2}
    end
  end
  
  def fold_y(coord)
    l, r = dots[0..coord-1], dots[coord+1..-1].reverse
    # Pad them to the same size
    if l.length > r.length
      r = Array.new(l.length-r.length, Array.new(l.first.length, false)) + r
    elsif r.length > l.length
      l = Array.new(r.length-l.length, Array.new(r.first.length, false)) + l
    end
    @dots = l.zip(r).map {|r1, r2| r1.zip(r2).map {|c1, c2| c1 | c2}}
  end
  
end

part1, part2 = $stdin.read.split("\n\n")
points = part1.split("\n").map {|l| l.split(",").map(&:to_i)}
instructions = part2.split("\n")

paper = Paper.new(points)
# Part 1
#paper.run!([instructions[0]])
# puts paper.n_visible

# Part 2
paper.run!(instructions)
puts paper
