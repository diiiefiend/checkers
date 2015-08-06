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
    [-1, -1],
    [-1, +1]
  ]

  PIECE_IMG = ["\u25CF", "\u25CB", "\u265B", "\u2655"]

  attr_reader :color, :board

  def initialize(color, pos, board)
    @color = color            #values: light and dark, :l & :d
    @pos = pos
    @board = board
    @king = false
  end

  def perform_slide(end_pos)
    return false unless sliding_moves.include?(end_pos)

    move(end_pos)
    self.king = true if promote?

    true
  end

  def perform_jump(end_pos)
    moves = jumping_moves
    return false unless moves.include?(end_pos)

    old_pos = pos
    move(end_pos)
    self.king = true if promote?
    board[captured_pos(old_pos, end_pos)] = nil

    true
  end

  def perform_moves!(move_arr)

  def move(end_pos)
    board[pos] = nil
    self.pos = end_pos
    board[pos] = self
  end

  def sliding_moves
    moves = []

    moveset.each do |vector|
      vector = vector.map { |i| i * move_dir } unless king?
      new_pos = pos.vector_add(vector)
      moves << new_pos if !board.occupied?(new_pos)
    end

    moves
  end

  def jumping_moves
    moves = []

    moveset.each do |vector|
      vector = vector.map { |i| i * move_dir } unless king?
      new_pos = pos.vector_add(vector.map { |i| i * 2 })
      captured_pos = captured_pos(pos, new_pos)

      if !board.occupied?(new_pos) && board.capturable?(captured_pos, color)
        moves << new_pos
      end
    end

    moves
  end

  def king?
    @king
  end

  def to_s
    if king?
      img = (color == :d ? PIECE_IMG[2] : PIECE_IMG[3])
    else
      img = (color == :d ? PIECE_IMG[0] : PIECE_IMG[1])
    end
    img.encode('utf-8') + " "
  end

  def inspect
    to_s + " @ #{pos}"
  end

  private
  attr_reader :move_dir
  attr_accessor :pos
  attr_writer :king

  def moveset
    king? ? PAWN_DELTAS + KING_DELTAS : PAWN_DELTAS
  end

  def move_dir
    color == :d ? +1 : -1
  end

  def captured_pos(old_pos, new_pos)
    x_arr = [old_pos[0], new_pos[0]]
    y_arr = [old_pos[1], new_pos[1]]

    [x_arr.max - 1, y_arr.max - 1]
  end

  def promote?
    color == :d ? pos[0] == 7 : pos[0] == 0
  end

end
