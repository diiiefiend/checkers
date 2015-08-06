require_relative 'piece.rb'

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
  end

  def render
  end

  def occupied?(pos)
    !self[pos].nil?
  end

  def in_bounds?(pos)
    pos.all? { |i| i.between?(0, BOARD_SIZE - 1) }
  end

  private

  def populate_grid
  end

end
