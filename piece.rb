require_relative 'board.rb'

class Piece
  MOVE_DELTAS = [
    [-1, -1],
    [-1, +1],
    [+1, -1],
    [+1, +1]
  ]

  attr_reader :color, :king, :pos, :board

  def initialize(color, pos, board)
    @color = color            #light and dark, :l & :d
    @pos = pos
    @board = board
    @king = false
  end

  def perform_slide
  end

  def perform_jump
  end

  def move_diffs
  end

  def promote?
  end

  def to_s
  end

end
