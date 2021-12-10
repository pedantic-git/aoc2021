#!/usr/bin/env ruby

class Board
  WINNING_COMBOS = [
    [0,1,2,3,4],
    [5,6,7,8,9],
    [10,11,12,13,14],
    [15,16,17,18,19],
    [20,21,22,23,24],
    [0,5,10,15,20],
    [1,6,11,16,21],
    [2,7,12,17,22],
    [3,8,13,18,23],
    [4,9,14,19,24]
  ]  
  
  # Pass it an array of 25 integers
  def initialize(grid)
    @grid = grid
    @last_call = nil
  end
  
  # Call a number - set its cell to nil if found
  def call(n)
    @last_call = n
    @grid.map! {|el| el == n ? nil : el}
  end
  
  # Are any of WINNING_COMBOS all nil
  def win?
    WINNING_COMBOS.each do |combo|
      return true if @grid.values_at(*combo).compact.empty?
    end
    false
  end
  
  def score
    return unless win?
    @grid.compact.sum * @last_call
  end
end

class Bingo
  def initialize(lines)
    @boards = []
    @calls = lines.shift.split(',').map(&:to_i)
    while lines.length > 0
      lines.shift
      @boards << Board.new(lines.shift(5).join.split(/\s+/).map(&:to_i))
    end
  end
  
  def run
    @calls.each do |c|
      @boards.each do |b|
        b.call c
        return b.score if b.win?
      end
    end
  end
end

puts Bingo.new($stdin.readlines).run
