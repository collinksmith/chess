require_relative 'piece'

class King < Piece
  MOVE_DIFFS = [[1, 1], [1, 0], [1, -1], [0, -1],
                [-1, -1], [-1, 0], [-1, 1], [0, 1]]

  include Stepable

  def initialize(color, board, pos)
    super(color, board, pos)
    @icon = color == :black ? "\u265A".black : "\u265A"
  end

  def valid_move?(end_pos)
    valid_step?(end_pos)
  end

  def king?
    true
  end
end
