require_relative 'piece'

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
