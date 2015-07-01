require_relative 'piece'

class Bishop < Piece
  include Diagonalable

  def initialize(color, board, pos)
    super(color, board, pos)
    @icon = color == :black ? "\u265D".black : "\u265D"
  end

  def valid_move?(end_pos)
    valid_diagonal?(end_pos) && !moves_into_check?(end_pos)
  end

end
