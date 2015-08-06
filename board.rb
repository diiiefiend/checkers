require_relative 'piece.rb'

class Board
  BOARD_SIZE = 8

  attr_reader :grid

  def initialize(fill_grid = true)
    @grid = Array.new(BOARD_SIZE) { Array.new(BOARD_SIZE) }
    populate_grid if fill_grid
  end

  def [](x, y)
    grid[x][y]
  end

  def []=(x, y, piece)
    grid[x][y] = piece
  end

  def dup
  end

  def render
  end

  def occupied?(pos)
  end

  def in_bounds?(pos)
  end

  private

  def populate_grid
  end

end
