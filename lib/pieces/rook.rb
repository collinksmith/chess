require_relative 'piece'

class Rook < Piece
  include Straightable

  def initialize(color, board, pos)
    super(color, board, pos)
    @icon = color == :black ? "\u265C".black : "\u265C"
  end

  def valid_move?(end_pos)
    valid_straight?(end_pos) && !moves_into_check?(end_pos)
  end
end
