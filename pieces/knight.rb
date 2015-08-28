require_relative 'piece'

class Knight < Piece
  MOVE_DIFFS = [[2, 1], [2, -1], [1, 2], [1, -2],
                [-2, 1], [-2, -1], [-1, 2], [-1, -2]]

  include Stepable

  def initialize(color, board, pos)
    super(color, board, pos)
    @icon = color == :black ? "\u265E".black : "\u265E"
  end

  def valid_move?(end_pos)
    valid_step?(end_pos)
  end
end
