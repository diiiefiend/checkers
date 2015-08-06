require_relative 'board.rb'
require_relative 'piece.rb'

class HumanPlayer
  attr_reader :color, :board

  def initialize(color, board)
    @color = color
    @board = board
  end

  def prompt
    moves = []

    puts "#{to_s}: Which piece to move? like so: 0,0"
    pos = gets.chomp.split(",").map { |i| Integer(i) }

    raise WrongInputError.new("FOLLOW THE FORMAT") if pos.length != 2
    raise NoPieceError.new("NO PIECE THERE") if !board.in_bounds?(pos) ||
      board[pos].nil?
    raise NotYourColorError.new("NOT YOUR COLOR") if board[pos].color != color

    puts "#{to_s}: Input move sequence, ie 1,2; 2,3"
    moves_str = gets.chomp.split("; ")
    moves_str.each { |move| moves << move.split(",").map(&:to_i) }

    [pos, moves]
  end

  def to_s
    color.to_s.upcase
  end
end

class ComputerPlayer
  attr_reader :color, :board

  def initialize(color, board)
    @color = color
    @board = board
  end

  def prompt
    pieces = board.all_pieces.select { |piece| piece.color == color }
    possible_moves = {}

    pieces.each do |piece|
      if !piece.jump_moves.empty?
        return chain_jump(piece.pos, piece.jump_moves.sample)
      elsif !piece.slide_moves.empty?
        possible_moves[piece.pos] = piece.slide_moves
      end
    end

    pos = possible_moves.keys.sample
    move = [possible_moves[pos].sample]

    [pos, move]
  end

  def to_s
    color.to_s.upcase
  end

  private
  def chain_jump(start_pos, move)
    moves = []

    test_pos = start_pos
    b = board.dup
    begin
      moves << move
      b[test_pos].perform_moves!([move])
      test_pos = move
      move = b[test_pos].jump_moves.sample
    end while b[test_pos].valid_move_seq?([move], false)

    [start_pos, moves]
  end
end

class NoPieceError < StandardError
end

class NotYourColorError < StandardError
end

class WrongInputError < StandardError
end
