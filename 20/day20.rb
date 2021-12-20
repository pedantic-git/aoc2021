#!/usr/bin/env ruby

class Image
  attr_reader :algo, :image
  
  def initialize(algo, input)
    @algo = algo
    @image = input
  end
  
  def to_s
    image.map {|r| r.map {|c| c == 1 ? '█' : ' '}.join+"\n"}.join
  end
  
  def enhance!
    add_border!
    copy_of_image.then do |copy|
      image.each_index do |y|
        image.first.each_index do |x|
          image[y][x] = algo[value_of x, y, copy] ? 1 : 0
        end
      end
    end
  end
  
  def count_lit
    image.flatten.tally[1]
  end
  
  private
  
  def add_border!
    image.each do |row|
      row.unshift(0)
      row.push(0)
    end
    blank_row = Array.new(image.first.length, 0)
    image.unshift(blank_row)
    image.push(blank_row.dup)
  end
  
  def copy_of_image
    image.map {|r| r.dup}
  end
  
  # Find the value of the given cell in the given image copy
  def value_of(x, y, copy)
    [
      [x-1, y-1], [x, y-1], [x+1, y-1],
      [x-1, y], [x, y], [x+1, y],
      [x-1, y+1], [x, y+1], [x+1, y+1]
    ].map do |x,y|
      if x < 0 || y < 0 || x >= copy.first.length || y >= copy.length
        0
      else
        copy[y][x]
      end
    end.join.to_i(2)
  end
  
end

algo_str, input_str = $stdin.read.split("\n\n")
algo = algo_str.delete("\n").split('').map {|c| c == '#' }
input = input_str.lines.map {|l| l.chomp.split('').map {|c| c == '#' ? 1:0}}

image = Image.new(algo, input)
2.times { image.enhance! }
puts image
puts image.count_lit
