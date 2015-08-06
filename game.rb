require_relative 'board.rb'
require_relative 'piece.rb'

class Game
  attr_reader :player1, :player2, :board
  attr_accessor :current_player

  def initialize
    @current_player = player2
    @board = Board.new
    @player1 = HumanPlayer.new(:d, @board)
    @player2 = HumanPlayer.new(:l, @board)
  end

  def play
    system("clear")
    until won?
      board.render
      switch_players
      begin
        piece, moves = current_player.prompt
        board[piece].perform_moves(moves)
      rescue StandardError, BadMoveError => e
        puts e.message
        retry
      end
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
    piece = gets.chomp.split(",").map { |i| Integer(i) }

    raise WrongInputError.new("FOLLOW THE FORMAT") if piece.length != 2
    raise NoPieceError.new("NO PIECE THERE") if !board.in_bounds?(piece) ||
      board[piece].nil?
    raise NotYourColorError.new("NOT YOUR COLOR") if board[piece].color != color

    puts "#{to_s}: Input move sequence, ie 1,2; 2,3"
    moves_str = gets.chomp.split("; ")
    moves_str.each { |move| moves << move.split(",").map(&:to_i) }

    [piece, moves]
  end

  def to_s
    color.to_s.upcase
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
