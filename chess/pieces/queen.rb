require_relative 'piece'

class Queen < Piece
  include Diagonalable
  include Straightable

  def initialize(color, board, pos)
    super(color, board, pos)
    @icon = color == :black ? "\u265B".black : "\u265B"
  end

  def valid_move?(end_pos)
    (valid_diagonal?(end_pos) || valid_straight?(end_pos)) &&
    !moves_into_check?(end_pos)
  end

end
