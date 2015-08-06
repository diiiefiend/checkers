require_relative 'board.rb'
require_relative 'piece.rb'
require_relative 'players.rb'
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

if __FILE__ == $PROGRAM_NAME
  g = Game.new
  g.play
end
