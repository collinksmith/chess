module Diagonalable

  def valid_diagonal?(end_pos)
    return false if pos == end_pos

    row_change = end_pos[0] - pos[0]
    col_change = end_pos[1] - pos[1]
    return false if row_change.abs != col_change.abs

    row_sign = row_change < 0 ? -1 : 1
    col_sign = col_change < 0 ? -1 : 1

    1.upto(row_change.abs) do |change|
      current_pos = [pos.first + change * row_sign, pos.last + change * col_sign]
      if current_pos == end_pos
        return true unless board[*current_pos].color == color
      else
        return false unless board[*current_pos].empty?
      end
    end

    false
  end


end
