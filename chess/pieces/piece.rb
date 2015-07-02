require_relative '../modules/diagonalable'
require_relative '../modules/straightable'
require_relative '../modules/stepable'

class Piece
  attr_reader :icon, :color, :board
  attr_accessor :pos

  def initialize(color, board, pos)
    @color, @board, @pos = color, board, pos
  end

  def to_s
    " #{icon.to_s} "
  end

  def empty?
    false
  end

  def dup(new_board)
    self.class.new(color, new_board, pos.dup)
  end

  def king?
    false
  end

  def moves_into_check?(end_pos)
    return false if board[*end_pos].king?

    new_board = board.dup
    new_board.move!(pos, end_pos)
    new_board.in_check?(color)
  end

  def valid_moves
    board.positions.select { |pos| valid_move?(pos) }
  end
end
