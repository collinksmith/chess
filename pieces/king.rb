require_relative 'piece'
require 'byebug'

class King < Piece
  MOVE_DIFFS = [[1, 1], [1, 0], [1, -1], [0, -1],
                [-1, -1], [-1, 0], [-1, 1], [0, 1]]

  include Stepable

  def initialize(color, board, pos)
    super(color, board, pos)
    @icon = color == :black ? "\u265A".black : "\u265A"
  end

  def valid_move?(end_pos)
    valid_step?(end_pos) || valid_castle?(end_pos)
  end

  def king?
    true
  end

  private

  def valid_castle?(end_pos)
    home_row = pos[0]

    # Check if position is occupied
    return false if board[*end_pos].is_a?(Piece)

    # Check is king has moved
    return false if moved?

    # Check if end pos is a valid position for a castle
    return false unless end_pos[0] == home_row &&
                        (end_pos[1] == 1 || end_pos[1] == 6)

    # Check if the rook has moved
    dir = pos[1] > 4 ? 1 : -1
    rook = self.board[home_row, end_pos[1] + 1]
    return false if rook.moved?

    true
  end
end
