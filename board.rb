require_relative 'piece.rb'
require 'colorize'

class Board
  BOARD_SIZE = 8

  attr_reader :grid

  def initialize(fill_grid = true)
    @grid = Array.new(BOARD_SIZE) { Array.new(BOARD_SIZE) }
    populate_grid if fill_grid
  end

  def [](pos)
    x, y = pos
    grid[x][y]
  end

  def []=(pos, piece)
    x, y = pos
    grid[x][y] = piece
  end

  def dup
    #...
  end

  def render
    puts "   0 1 2 3 4 5 6 7"
    grid.each_with_index do |row, idx|
      print "#{idx}: "
      row.each_with_index do |tile, idy|
        bg_color = ((idx + idy).even? ? :light_white : :gray)
        output = tile.nil? ? "  " : tile.to_s
        print output.colorize(:background => bg_color)
      end
      print "\n"
    end
    puts "\n\n"
  end

  def occupied?(pos)
    in_bounds?(pos) && !self[pos].nil?
  end

  def capturable?(pos, color)
    occupied?(pos) && self[pos].color != color
  end

  def in_bounds?(pos)
    pos.all? { |i| i.between?(0, BOARD_SIZE - 1) }
  end

  private

  def populate_grid
    #...
  end

end
