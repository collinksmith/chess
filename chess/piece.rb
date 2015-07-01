require_relative 'diagonalable'
require_relative 'straightable'
require_relative 'stepable'
require 'byebug'

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
    new_board = board.dup
    new_board.move!(pos, end_pos)
    new_board.in_check?(color)
  end

  def valid_moves
    board.positions.select { |pos| valid_move?(pos) }
  end

end

class Pawn < Piece

  def initialize(color, board, pos)
    super(color, board, pos)
    @icon = color == :black ? "\u265F".black : "\u265F"
  end

  def valid_move?(end_pos)
    home_row = (color == :white) ? 6 : 1
    row_diff, col_diff = end_pos[0] - pos[0], end_pos[1] - pos[1]
    correct_sign = (color == :black) ? 1 : -1

    if correct_sign > 0 && row_diff <= 0 || correct_sign < 0 && row_diff >= 0
      return false
    elsif col_diff != 0
      return false if col_diff.abs > 1 || row_diff.abs > 1
      return false if board[*end_pos].color == color || board[*end_pos].empty?
    elsif pos[0] == home_row
      return false unless row_diff.abs <= 2
      return false unless board[pos[0] + correct_sign, pos[1]].empty?
      if row_diff.abs == 2
        return false unless board[pos[0] + row_diff, pos[1]].empty?
      end
    else
      return false unless row_diff.abs == 1
      return false unless board[pos[0] + correct_sign, pos[1]].empty?
    end

  !moves_into_check?(end_pos)
  end

end

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

class Knight < Piece
  MOVE_DIFFS = [[2, 1], [2, -1], [1, 2], [1, -2],
                [-2, 1], [-2, -1], [-1, 2], [-1, -2]]

  include Stepable

  def initialize(color, board, pos)
    super(color, board, pos)
    @icon = color == :black ? "\u265E".black : "\u265E"
  end

end

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

class King < Piece
  MOVE_DIFFS = [[1, 1], [1, 0], [1, -1], [0, -1],
                [-1, -1], [-1, 0], [-1, 1], [0, 1]]

  include Stepable

  def initialize(color, board, pos)
    super(color, board, pos)
    @icon = color == :black ? "\u265A".black : "\u265A"
  end

  def king?
    true
  end

end
