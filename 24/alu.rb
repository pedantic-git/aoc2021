#!/usr/bin/env ruby

INSTRUCTIONS = DATA.readlines

require 'pry'

class ALU
  
  attr_accessor :reg, :input
  def initialize(input=[])
    @reg = {'w' => 0, 'x' => 0, 'y' => 0, 'z' => 0}
    @input = input
    mod!
    INSTRUCTIONS.each(&method(:step!))
  end
  
  def mod!
    z2 = (26*(input[0]+15)) + input[1] + 8
    z4 = if input[3] == input[2]-7
      z2
    else
      26*z2 + input[3] + 6
    end
    reg['z'] = 26*z4 + input[4] + 13
    input.shift(5)
  end
  
  def step!(instruction)
    case instruction
    when /#/
      # no-op
    when /inp (\w)/
      reg[$1] = input.shift
    when /add (\w) (\S*)/
      reg[$1] += reg[$2] || $2.to_i
    when /mul (\w) (\S*)/
      reg[$1] *= reg[$2] || $2.to_i
    when /div (\w) (\S*)/
      reg[$1] /= reg[$2] || $2.to_i
    when /mod (\w) (\S*)/
      reg[$1] %= reg[$2] || $2.to_i
    when /eql (\w) (\S*)/
      reg[$1] = (reg[$1] == (reg[$2] || $2.to_i) ? 1:0)
    end
    if /####/ =~ instruction
      puts instruction
      p self
    end
  end
  
  def pass?
    reg["z"] == 0
  end
  
end

serial = ARGV[0]&.split('')&.map(&:to_i) or fail "Please supply serial"
alu = ALU.new(serial)
p alu
p alu.pass?

__END__
inp w # w = digits[0]
mul x 0 # x = 0
add x z # x = 0
mod x 26 # x = 0
div z 1 # z = 0
add x 10 # x = 10
eql x w # x = 0 (w can never be 10)
eql x 0 # x = 1 (x will definitely be 0)
mul y 0 # y = 0
add y 25 # y = 25
mul y x # y = 25
add y 1 # y = 26
mul z y # z = 0
mul y 0 # y = 0
add y w # y = digits[0]
add y 15 # y = digits[0] + 15
mul y x # y = digits[0] + 15
add z y ###### z = digits[0] + 15
inp w # w = digits[1]
mul x 0 # x = 0
add x z # x = digits[0] + 15
mod x 26 # x = digits[0] + 15 (can never be greater than 26)
div z 1 # z = digits[0] + 15
add x 12 # x = digits[0] + 27
eql x w # x = 0 (can never be 27+)
eql x 0 # x = 1 (x will definitely be 0)
mul y 0 # y = 0
add y 25 # y = 25
mul y x # y = 25
add y 1 # y = 26
mul z y # z = 26 * (digits[0] + 15)
mul y 0 # y = 0
add y w # y = digits[1]
add y 8 # y = digits[1] + 8
mul y x # y = digits[1] + 8
add z y ####### z = (26 * (d0 + 15)) + d1 + 8
inp w # w = d2
mul x 0 # x = 0
add x z # x = (26 * (d0 + 15)) + d1 + 8
mod x 26 # x = ((26 * (d0 + 15)) + d1 + 8) % 26
div z 1 # z is unchanged
add x 15 # x = (((26 * (d0 + 15)) + d1 + 8) % 26) + 15
eql x w # x = 0 (cannot be 15+)
eql x 0 # x = 1
mul y 0 # y = 0
add y 25 # y = 25
mul y x # y = 25
add y 1 # y = 26
mul z y # z = 26*((26 * (d0 + 15)) + d1 + 8)
mul y 0 # y = 0
add y w # y = d2
add y 2 # y = d2 + 2
mul y x # y = d2 + 2
add z y ####### z = (26*((26 * (d0 + 15)) + d1 + 8)) + d2 + 2
inp w # w = d3
mul x 0 # x = 0
add x z # x = (26*((26 * (d0 + 15)) + d1 + 8)) + d2 + 2
mod x 26 # x = d2+2
div z 26 # z = ((26*(d0+15)) + d1 + 8) [no d2 because d2+2 will never be 26+]
add x -9 # x = d2-7
eql x w # x = (d3==d2-7) ? 1 : 0
eql x 0 # x = (d3==d2-7) ? 0 : 1
mul y 0 # y = 0
add y 25 # y = 25
mul y x # y = (d3==d2-7) ? 0 : 25
add y 1 # y = (d3==d2-7) ? 1 : 26
mul z y # z = (d3==d2-7) ? ((26*(d0+15)) + d1 + 8) : 26*((26*(d0+15)) + d1 + 8)
mul y 0 # y = 0
add y w # y = d3
add y 6 # y = d3 + 6
mul y x # y = (d3==d2-7) ? 0 : (6*d3)
add z y ##### z = (d3==d2-7) ? ((26*(d0+15)) + d1 + 8) : 26*((26*(d0+15)) + d1 + 8) + d3 + 6
inp w # w = d4
mul x 0 # x = 0
add x z # x = (d3==d2-7) ? ((26*(d0+15)) + d1 + 8) : 26*((26*(d0+15)) + d1 + 8) + d3 + 6
mod x 26 # x = (d3==d2-7) ? (d1 + 8) : (d3 + 6)
div z 1 # noop
add x 15 # x = (d3==d2-7) ? (d1 + 23) : (d3 + 21)
eql x w # x = 0 
eql x 0 # x = 1
mul y 0 # y = 0
add y 25 # y = 25
mul y x # y = 25
add y 1 # y = 26
mul z y # z = 26* ( (d3==d2-7) ? ((26*(d0+15)) + d1 + 8) : 26*((26*(d0+15)) + d1 + 8) + d3 + 6 )
mul y 0 # y = 0
add y w # y = d4
add y 13 # y = d4 + 13
mul y x # y = d4 + 13
add z y #### z = 26* ( (d3==d2-7) ? ((26*(d0+15)) + d1 + 8) : 26*((26*(d0+15)) + d1 + 8) + d3 + 6 ) + d4 + 13
inp w
mul x 0
add x z
mod x 26
div z 1
add x 10
eql x w
eql x 0
mul y 0
add y 25
mul y x
add y 1
mul z y
mul y 0
add y w
add y 4
mul y x
add z y
inp w
mul x 0
add x z
mod x 26
div z 1
add x 14
eql x w
eql x 0
mul y 0
add y 25
mul y x
add y 1
mul z y
mul y 0
add y w
add y 1
mul y x
add z y
inp w
mul x 0
add x z
mod x 26
div z 26
add x -5
eql x w
eql x 0
mul y 0
add y 25
mul y x
add y 1
mul z y
mul y 0
add y w
add y 9
mul y x
add z y
inp w
mul x 0
add x z
mod x 26
div z 1
add x 14
eql x w
eql x 0
mul y 0
add y 25
mul y x
add y 1
mul z y
mul y 0
add y w
add y 5
mul y x
add z y
inp w
mul x 0
add x z
mod x 26
div z 26
add x -7
eql x w
eql x 0
mul y 0
add y 25
mul y x
add y 1
mul z y
mul y 0
add y w
add y 13
mul y x
add z y
inp w
mul x 0
add x z
mod x 26
div z 26
add x -12
eql x w
eql x 0
mul y 0
add y 25
mul y x
add y 1
mul z y
mul y 0
add y w
add y 9
mul y x
add z y
inp w
mul x 0
add x z
mod x 26
div z 26
add x -10
eql x w
eql x 0
mul y 0
add y 25
mul y x
add y 1
mul z y
mul y 0
add y w
add y 6
mul y x
add z y
inp w
mul x 0
add x z
mod x 26
div z 26
add x -1
eql x w
eql x 0
mul y 0
add y 25
mul y x
add y 1
mul z y
mul y 0
add y w
add y 2
mul y x
add z y
inp w
mul x 0
add x z
mod x 26
div z 26
add x -11
eql x w
eql x 0
mul y 0
add y 25
mul y x
add y 1
mul z y
mul y 0
add y w
add y 2
mul y x
add z y
