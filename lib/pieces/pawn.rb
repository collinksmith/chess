require_relative 'piece'

class Pawn < Piece
  def initialize(color, board, pos)
    super(color, board, pos)
    @icon = color == :black ? "\u265F".black : "\u265F"
  end

  def valid_move?(end_pos)
    return false unless valid_direction?(end_pos)
    row_diff, col_diff = end_pos[0] - pos[0], end_pos[1] - pos[1]
    return false unless row_diff.abs.between?(1, 2)

    if col_diff != 0
      return false unless valid_attack?(end_pos, row_diff, col_diff)
    else
      return false unless valid_non_attack?(end_pos, row_diff)
    end

    !moves_into_check?(end_pos)
  end

  def valid_non_attack?(end_pos, row_diff)
    if moved?
      row_diff.abs == 1 && board[*end_pos].empty?
    else
      valid_first_move?(end_pos, row_diff)
    end
  end

  def valid_first_move?(end_pos, row_diff)
    sign = (color == :white) ? -1 : 1
    if row_diff.abs == 2
      path = [board[*end_pos], board[pos.first + sign, pos.last]]
      path.all? { |piece| piece.empty? }
    else
      board[*end_pos].empty?
    end
  end

  def valid_attack?(end_pos, row_diff, col_diff)
    other_color = (color == :white) ? :black : :white
    end_piece = board[*end_pos]
    row_diff.abs == 1 && col_diff.abs == 1 && end_piece.color == other_color
  end

  def valid_direction?(end_pos)
    if color == :black
      end_pos.first > pos.first
    else
      end_pos.first < pos.first
    end
  end

  def moved?
    home_row = (color == :white) ? 6 : 1
    pos.first != home_row
  end

  def can_promote?
    if color == :white
      return pos[0] == 0
    else
      return pos[0] == 7
    end
  end
end
