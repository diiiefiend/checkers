require_relative 'board.rb'
require_relative 'piece.rb'
require 'byebug'

class Game
  attr_reader :player1, :player2, :board
  attr_accessor :current_player

  def initialize
    @current_player = player2
    @board = Board.new
    @player1 = ComputerPlayer.new(:d, @board)
    @player2 = ComputerPlayer.new(:l, @board)
  end

  def play
    system("clear")
    until won?
      board.render
      switch_players
      begin
        pos, moves = current_player.prompt
        board[pos].perform_moves(moves)
      rescue StandardError, BadMoveError => e
        puts e.message
        retry
      end
      puts "#{pos} => #{moves}"
      sleep(1)
      system("clear")
    end
    board.render
    puts "CONGRATS #{current_player} YOU ERADICATED THE ENEMY!!!"
  end

  def play_turn(piece, moves)
    board[piece].perform_moves(moves)
  end

  def switch_players
    self.current_player = (current_player == player1 ? player2 : player1)
  end

  def won?
    pieces = board.all_pieces
    pieces.all? { |piece| piece.color == pieces[0].color }
  end
end

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
    moves = []
    possible_moves = {}

    pieces.each do |piece|
      if !piece.jump_moves.empty?
        pos = piece.pos
        move = piece.jump_moves.sample

        test_pos = pos
        b = board.dup
        begin
          moves << move
          b[test_pos].perform_moves!([move])
          test_pos = move
          move = b[test_pos].jump_moves.sample
        end while b[test_pos].valid_move_seq?([move], false)

        return [pos, moves]
      elsif !piece.slide_moves.empty?
        possible_moves[piece.pos] = piece.slide_moves
      end
    end

    pos = possible_moves.keys.sample
    move = [possible_moves[pos].sample]

    [pos, move]
  end

end

class NoPieceError < StandardError
end

class NotYourColorError < StandardError
end

class WrongInputError < StandardError
end

if __FILE__ == $PROGRAM_NAME
  g = Game.new
  g.play
end
