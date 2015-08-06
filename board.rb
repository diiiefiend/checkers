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
    board_copy = Board.new(false)
    all_pieces.each do |piece|
      Piece.new(piece.color, piece.pos, board_copy, piece.king?)
    end

    board_copy
  end

  def all_pieces
    grid.flatten.compact
  end

  def render
    puts "   0 1 2 3 4 5 6 7"
    grid.each_with_index do |row, idx|
      print "#{idx}: "
      row.each_with_index do |tile, idy|
        bg_color = ((idx + idy).even? ? :gray : :light_white)
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
    dark_rows = (0..2).to_a
    light_rows = (5..7).to_a

    (dark_rows + light_rows).each_with_index do |row, idx|
      color = (dark_rows.include?(row) ? :d : :l)
      0.upto(BOARD_SIZE-1) do |col|
        Piece.new(color, [row, col], self) if (idx + col).odd?
      end
    end
  end
end
