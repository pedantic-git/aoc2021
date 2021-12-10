#!/usr/bin/env ruby

class Sub
  def initialize
    @h = 0
    @v = 0
    @a = 0
  end
  
  def move(str)
    case str
    when /forward (\d+)/
      @h += $1.to_i
      @v += $1.to_i * @a
    when /up (\d+)/
      @a -= $1.to_i
    when /down (\d+)/
      @a += $1.to_i
    end
  end
  
  def pos
    @h * @v
  end
end

s = Sub.new
$stdin.readlines.each {|l| s.move l}
puts s.pos
