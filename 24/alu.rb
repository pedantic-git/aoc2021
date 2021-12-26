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
    z7div26 = 26*(26*z4 + input[4] + 13) + input[5] + 4
    z8 = if input[7] == input[6]-4
      z7div26
    else
      26*z7div26 + input[7] + 9
    end
    z10 = if input[9] == input[8]-2
      z8
    else
      26*z8 + input[9] + 13
    end
    # refactor this
    z10div26 = z10/26
    
    cond1 = if input[9] == input[8]-2
      if input[7] == input[6] - 4
        input[5] - 8
      else
        input[7] - 3
      end
    else
      input[9] + 1
    end
    
    z11 = if input[10] == cond1
      z10div26
    else
      26*z10div26 + input[10] + 9
    end
    
    input.shift(11)
    reg["z"] = z11
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
add z y ###### z1 = digits[0] + 15
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
add z y ####### z2 = (26 * (d0 + 15)) + d1 + 8
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
add z y ####### z3 = (26*((26 * (d0 + 15)) + d1 + 8)) + d2 + 2
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
add z y ##### z4 = (d3==d2-7) ? ((26*(d0+15)) + d1 + 8) : 26*((26*(d0+15)) + d1 + 8) + d3 + 6
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
add z y #### z5 = 26* ( (d3==d2-7) ? ((26*(d0+15)) + d1 + 8) : 26*((26*(d0+15)) + d1 + 8) + d3 + 6 ) + d4 + 13
inp w # w = d5
mul x 0 # x = 0
add x z # x = 26* ( (d3==d2-7) ? ((26*(d0+15)) + d1 + 8) : 26*((26*(d0+15)) + d1 + 8) + d3 + 6 ) + d4 + 13
mod x 26 # x = d4 + 13
div z 1 # no op
add x 10 # x = d4 + 23
eql x w # x = 0
eql x 0 # x = 1
mul y 0 # y = 0
add y 25 # y = 25
mul y x # y = 25
add y 1 # y = 26
mul z y # z = 26* (26* ( (d3==d2-7) ? ((26*(d0+15)) + d1 + 8) : 26*((26*(d0+15)) + d1 + 8) + d3 + 6 ) + d4 + 13)
mul y 0 # y = 0
add y w # y = d5
add y 4 # y = d5 + 4
mul y x # y = d5 + 4
add z y ##### z6 = 26* (26* ( (d3==d2-7) ? ((26*(d0+15)) + d1 + 8) : 26*((26*(d0+15)) + d1 + 8) + d3 + 6 ) + d4 + 13) + d5 + 4
inp w # w = d6
mul x 0 # x = 0
add x z # x = 26* (26* ( (d3==d2-7) ? ((26*(d0+15)) + d1 + 8) : 26*((26*(d0+15)) + d1 + 8) + d3 + 6 ) + d4 + 13) + d5 + 4
mod x 26 # x = d5 + 4
div z 1 # no op
add x 14 # x = d5 + 18
eql x w # x = 0
eql x 0 # x = 1
mul y 0 # y = 0
add y 25 # y = 25
mul y x # y = 25
add y 1 # y = 26
mul z y # z = 26* (26* (26* ( (d3==d2-7) ? ((26*(d0+15)) + d1 + 8) : 26*((26*(d0+15)) + d1 + 8) + d3 + 6 ) + d4 + 13) + d5 + 4)
mul y 0 # y = 0
add y w # y = d6
add y 1 # y = d6 + 1
mul y x # y = d6 + 1
add z y ###### z7 = 26* (26* (26* ( (d3==d2-7) ? ((26*(d0+15)) + d1 + 8) : 26*((26*(d0+15)) + d1 + 8) + d3 + 6 ) + d4 + 13) + d5 + 4) + d6 + 1
inp w # w = d7
mul x 0 # x = 0
add x z # x = z7
mod x 26 # x = d6 + 1 [the only part of z7 that's not a multiple of 26]
div z 26 ###### z = z7div26 = (26* (26* ( (d3==d2-7) ? ((26*(d0+15)) + d1 + 8) : 26*((26*(d0+15)) + d1 + 8) + d3 + 6 ) + d4 + 13) + d5 + 4)
add x -5 # x = d6 - 4
eql x w # x = (d7 == d6 - 4 ? 1 : 0)
eql x 0 # x = (d7 == d6 - 4 ? 0 : 1)
mul y 0 # y = 0
add y 25 # y = 25
mul y x # y = (d7 == d6 - 4 ? 0 : 25)
add y 1 # y = (d7 == d6 - 4 ? 1 : 26)
mul z y # z = d7==d6-4 ? z7div26 : 26*z7div26
mul y 0 # y = 0
add y w # y = d7
add y 9 # y = d7 + 9
mul y x # y = d7==d6-4 ? 0 : d7+9
add z y #### z8 = d7==d6-4 ? z7div26 : 26*z7div26 + d7 + 9
inp w # w = d8
mul x 0 # x = 0
add x z # x = z8
mod x 26 # x = d7==d6-4 ? d5+4 : d7+9
div z 1 # no op
add x 14 # x = d7==d4-4 ? d5+18 : d7+23
eql x w # x = 0
eql x 0 # x = 1
mul y 0 # y = 0
add y 25 # y = 25
mul y x # y = 25
add y 1 # y = 26
mul z y # z = 26 * z8
mul y 0 # y = 0
add y w # y = d8
add y 5 # y = d8 + 5
mul y x # y = d8 + 5
add z y ##### z9 = (26 * z8) + d8 + 5
inp w # w = d9
mul x 0 # x = 0
add x z # x = z9
mod x 26 # x = d8 + 5
div z 26 # z = z8
add x -7 # x = d8 - 2
eql x w # x = d9 == d8-2 ? 1 : 0
eql x 0 # x = d9 == d8-2 ? 0 : 1
mul y 0 # y = 0
add y 25 # y = 25
mul y x # y = d9==d8-2 ? 0 : 25
add y 1 # y = d9==d8-2 ? 1 : 26
mul z y # z = d9==d8-2 ? z8 : 26*z8
mul y 0 # y = 0
add y w # y = d9
add y 13 # y = d9+13
mul y x # y = d9==d8-2 ? 0 : d9+13
add z y ##### z10 = d9==d8-2 ? z8 : 26*z8 + d9 + 13
inp w # w = d10
mul x 0 # x = 0
add x z # x = z10
mod x 26 # x = d9==d8-2 ? (d7 == d6-4 ? d5+4 : d7+9) : d9+13
div z 26 # z = z10div26 = d9==d8-2 ? z8div26 : z8 ## z8div26 = d7==d6-4 ? z7div26div26 : z7div26 ## z7div26div26 = (26* ( (d3==d2-7) ? ((26*(d0+15)) + d1 + 8) : 26*((26*(d0+15)) + d1 + 8) + d3 + 6 ) + d4 + 13)
add x -12 # x = cond1 = d9==d8-2 ? (d7 == d6-4 ? d5-8 : d7-3) : d9+1
eql x w # x = d10==cond1 ? 1 : 0
eql x 0 # x = d10==cond1 ? 0 : 1
mul y 0 # y = 0
add y 25 # y = 25
mul y x # y = d10==cond1 ? 0 : 25
add y 1 # y = d10==cond1 ? 1 : 26
mul z y # z = d10==cond1 ? z10div26 : 26*z10div26
mul y 0 # y = 0
add y w # y = d10
add y 9 # y = d10+9
mul y x # y = d10==cond1 ? 0 : d10+9
add z y ##### z11 = d10==cond1 ? z10div26 : 26*z10div26 + d10+9
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
