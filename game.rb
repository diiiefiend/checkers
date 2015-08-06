require_relative 'board.rb'
require_relative 'piece.rb'

class Game
end

if __FILE__ == $PROGRAM_NAME
  b = Board.new(false)
  b.render
  c = Piece.new(:d, [0, 0], b)
  p c.sliding_moves
  p c.perform_slide([1, 1])
  p c
  b.render
  d = Piece.new(:l, [3, 1], b)
  p d.perform_slide([2, 2])
  b.render
  p c.jumping_moves
  p c.perform_jump([3, 3])
  b.render
  p c.perform_jump([7, 7])
  b.render
  e = Piece.new(:d, [6, 6], b)
  p e.king?
  e.perform_slide([7, 7])
  b.render
  p e.king?
end
