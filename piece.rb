require_relative 'board.rb'

module Enumerable
  def sum
    inject(&:+)
  end

  def vector_add(other_arr)
    zip(other_arr).collect(&:sum)
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
  attr_reader :pos

  def initialize(color, pos, board, king = false)
    @color = color            #values: light and dark, :l & :d
    @pos = pos
    @board = board
    board[pos] = self
    @king = king
  end

  def perform_slide(end_pos)
    return false unless slide_moves.include?(end_pos)

    move(end_pos)
    self.king = true if promote?

    true
  end

  def perform_jump(end_pos)
    moves = jump_moves
    return false unless moves.include?(end_pos)

    old_pos = pos
    move(end_pos)
    self.king = true if promote?
    board[captured_pos(old_pos, end_pos)] = nil

    true
  end

  def perform_moves(move_arr)
    raise BadMoveError.new("NO CAN DO") unless valid_move_seq?(move_arr)
    perform_moves!(move_arr)
  end

  def perform_moves!(move_arr)
    if move_arr.length == 1
      move = move_arr[0]
      unless perform_slide(move) || perform_jump(move)
        raise BadMoveError.new("INVALID MOVE")
      end
    else
      move_arr.each do |move|
        raise BadMoveError.new("INVALID JUMP") unless perform_jump(move)
      end
    end
  end

  def move(end_pos)
    board[pos] = nil
    self.pos = end_pos
    board[pos] = self
  end

  def slide_moves
    moves = []

    moveset.each do |vector|
      vector = vector.map { |i| i * move_dir } unless king?
      new_pos = pos.vector_add(vector)
      moves << new_pos if board.in_bounds?(new_pos) && !board.occupied?(new_pos)
    end

    moves
  end

  def jump_moves
    moves = []

    moveset.each do |vector|
      vector = vector.map { |i| i * move_dir } unless king?
      new_pos = pos.vector_add(vector.map { |i| i * 2 })
      captured_pos = captured_pos(pos, new_pos)

      if board.in_bounds?(new_pos) && !board.occupied?(new_pos) &&
        board.capturable?(captured_pos, color)
        moves << new_pos
      end
    end

    moves
  end

  def valid_move_seq?(move_arr, display_error = true)
    board_copy = board.dup
    begin
      board_copy[pos].perform_moves!(move_arr)
    rescue BadMoveError => e
      puts e.message if display_error
      return false
    else
      return true
    end
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
  attr_writer :king, :pos

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

class BadMoveError < StandardError
end
