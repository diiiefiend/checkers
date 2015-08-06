require_relative 'board.rb'
require 'byebug'

module Enumerable
  def sum
    inject &:+
  end

  def vector_add(other_arr)
    zip(other_arr).collect &:sum
  end
end

class Piece
  PAWN_DELTAS = [
    [+1, +1],
    [+1, -1]
  ]

  KING_DELTAS = [
    [+1, -1],
    [+1, +1]
  ]

  attr_reader :color, :board

  def initialize(color, pos, board)
    @color = color            #values: light and dark, :l & :d
    @pos = pos
    @board = board
    @king = false
    color == :d ? @move_dir = +1 : @move_dir = -1
  end

  def perform_slide(end_pos)
    return false unless sliding_moves.include?(end_pos)

    move(end_pos)
    self.king = true if promote?

    true
  end

  def perform_jump(end_pos)
    moves, captured = jumping_moves
    return false unless moves.include?(end_pos)

    move(end_pos)
    self.king = true if promote?
    idx = moves.find_index(end_pos)
    board[captured[idx]] = nil

    true
  end

  def move(end_pos)
    board[pos] = nil
    self.pos = end_pos
    board[pos] = self
  end

  def sliding_moves
    moves = []

    moveset.each do |vector|
      vector = vector.map { |i| i * move_dir }
      new_pos = pos.vector_add(vector)
      moves << new_pos if board.in_bounds?(new_pos) && !board.occupied?(new_pos)
    end

    moves
  end

  def jumping_moves
    moves = []
    captured_pieces = []

    moveset.each do |vector|
      vector = vector.map { |i| i * move_dir }
      captured_pos = pos.vector_add(vector)
      new_pos = pos.vector_add(vector.map { |i| i * 2 })

      if board.in_bounds?(new_pos) && board.capturable?(captured_pos, color) &&
        !board.occupied?(new_pos)

        moves << new_pos
        captured_pieces << captured_pos
      end
    end

    [moves, captured_pieces]
  end

  def promote?
    color == :d ? pos[0] == 7 : pos[0] == 0
  end

  def king?
    king
  end

  def to_s
    if king?
      color == :d ? "K|" : "k|"
    else
      color == :d ? "D|" : "L|"
    end
  end

  def inspect
    to_s + " @ #{pos}"
  end

  private
  attr_reader :move_dir
  attr_accessor :pos, :king

  def moveset
    king? ? PAWN_DELTAS + KING_DELTAS : PAWN_DELTAS
  end

end
