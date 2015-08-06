require_relative 'board.rb'
require 'byebug'

class Piece
  PAWN_DELTAS = [
    [-1, -1],
    [-1, +1]
  ]

  KING_DELTAS = [
    [+1, -1],
    [+1, +1]
  ]

  attr_reader :color, :king, :pos, :board, :move_dir

  def initialize(color, pos, board)
    @color = color            #light and dark, :l & :d
    @pos = pos
    @board = board
    @king = false
    color == :d ? @move_dir = -1 : @move_dir = +1
  end

  def perform_slide(end_pos)

  end

  def perform_jump(end_pos)
  end

  def moves
    x, y = pos
    moves = []

    moveset.each do |vector|
      new_pos = [x + vector[0], y + vector[1]].map { |i| i * move_dir }
      moves << new_pos if board.in_bounds?(new_pos)
    end

    moves
  end

  def promote?
    color == :d ? pos[0] == 7 : pos[0] == 0
  end

  def to_s
    color == :d ? "D" : "L"
  end

  def inspect
    to_s + " @ #{pos}"
  end

  private

  def moveset
    king? ? PAWN_DELTAS + KING_DELTAS : PAWN_DELTAS
  end

  def king?
    king
  end

end
