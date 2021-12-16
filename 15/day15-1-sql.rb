#!/usr/bin/env ruby

require 'sqlite3'

# Base this on Dijkstra's algorithm

class Chitons
  
  attr_reader :db, :target
  
  def initialize(lines)
    create_db
    
    lines.each.with_index do |line, y|
      line.chomp.split('').each.with_index do |danger, x|
        db.execute("insert into chitons (xy, danger) values (?,?)", [
          "#{x},#{y}", danger.to_i
        ])
      end
    end
    @target = "#{lines.first.length - 2},#{lines.size - 1}"
  end
  
  # Keep running Dijkstra's algorithm until we have filled target's prev
  def calc!
    db.execute("update chitons set distance = 0 where xy = '0,0'")
    loop do
      best_guess = db.execute("select xy,distance from chitons where seen = false order by distance limit 1").first
      break if best_guess.nil?
      puts best_guess[0]
      db.execute("update chitons set seen = true where xy = ?", [best_guess[0]])
      neighbours_of(best_guess[0]).each do |neighbour|
        deets = db.execute("select distance, danger from chitons where seen = false and xy = ?", [neighbour]).first
        next if deets.nil?
        alt = best_guess[1] + deets[1]
        if alt < deets[0]
          db.execute("update chitons set distance = ?, prev = ? where xy = ?", [alt, best_guess[0], neighbour])
        end
      end
      break if db.execute("select prev from chitons where xy = ?", [target]).first&.first
    end
  end
  
  # Get the shortest distance to target
  def distance_to_target
    db.execute("select distance from chitons where xy = ?", [target]).first&.first
  end
  
  private
  
  def create_db
    File.delete 'day15.db' if File.exists? 'day15.db'
    @db = SQLite3::Database.new 'day15.db'
    @db.execute <<~SQL
      create table chitons (
        xy varchar not null primary key,
        seen bool default false,
        danger int not null,
        distance int default 10000,
        prev varchar
      );
      create index idx_distance on chitons (distance);
    SQL
  end
  
  # Get the 4 neighbours of a given pair of coords
  def neighbours_of(vertex)
    x, y = vertex.split(',').map(&:to_i)
    [
      [x+1, y],
      [x, y+1],
      [x-1, y],
      [x, y-1],
    ].map {|p| p.join(',')}
  end
  
end

c = Chitons.new($stdin.readlines)
c.calc!
p c.distance_to_target
