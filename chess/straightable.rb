module Straightable
  def valid_straight?(end_pos)
    return false if pos == end_pos

    row_change = end_pos[0] - pos[0]
    col_change = end_pos[1] - pos[1]
    return false unless row_change == 0 || col_change == 0

    if row_change == 0
      valid_horizontal?(end_pos, col_change)
    else
      valid_vertical?(end_pos, row_change)
    end
  end

  def valid_vertical?(end_pos, row_change)
    sign = row_change > 0 ? 1 : -1

    1.upto(row_change.abs) do |change|
      current_pos = [pos[0] + change * sign, pos[1]]
      if current_pos == end_pos
        return true unless board[*current_pos].color == color
      else
        return false unless board[*current_pos].empty?
      end
    end
    false
  end

  def valid_horizontal?(end_pos, col_change)
    sign = col_change > 0 ? 1 : -1

    1.upto(col_change.abs) do |change|
      current_pos = [pos[0], pos[1] + change * sign]
      if current_pos == end_pos
        return true unless board[*current_pos].color == color
      else
        return false unless board[*current_pos].empty?
      end
    end
    false
  end

end
