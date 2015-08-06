require_relative 'board.rb'
require_relative 'piece.rb'

class Game
end

if __FILE__ == $PROGRAM_NAME
  b = Board.new(false)
  p b
  c = Piece.new(:d, [0, 0], b)
  p c.moves
end
