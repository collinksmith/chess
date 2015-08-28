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

  def valid_castle?(end_pos)
    home_row = pos[0]

    # Check if position is occupied
    return false unless board[*end_pos].empty?

    # Check is king has moved
    return false if moved?

    # Check if end pos is a valid position for a castle
    return false unless end_pos[0] == home_row &&
                        (end_pos[1] == 2 || end_pos[1] == 6)

    # Check if there is still a rook that hasn't moved
    dir = end_pos[1] > 4 ? 1 : -1
    rook = dir > 0 ? board[home_row, 7] : board[home_row, 0]
    return false if rook.empty? || rook.moved?

    # Check if the line is open
    return false unless rook.valid_straight?([home_row, pos[1] + dir])

    # Return true if none of the above conditions are true
    true
  end
end
