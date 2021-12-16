#!/usr/bin/env ruby

# Create the larger input file for part 2

def increase_cell(cell)
  cell.map do |row|
    row.map do |chiton|
      (chiton + 1).then {|c| c == 10 ? 1 : c}
    end
  end
end

def row_starting_with(cell)
  [cell].tap do |row|
    4.times { row << increase_cell(row.last) }
  end
end

first_cell = $stdin.readlines.map {|l| l.chomp.split('').map(&:to_i)}
width = first_cell.length * 5

rows = [row_starting_with(first_cell)]

(1..4).each {|i| rows << row_starting_with(rows[0][i])}

rows.flatten.each_slice(width) do |slice|
  puts slice.join
end
