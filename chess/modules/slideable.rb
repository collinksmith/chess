module Slideable
  def valid_slide?(row_change, col_change, end_pos)
    row_mult = change_multiplier(row_change)
    col_mult = change_multiplier(col_change)

    total_change = [row_change.abs, col_change.abs].max

    1.upto(total_change) do |change|
      current_pos = [pos[0] + (change * row_mult), pos[1] + (change * col_mult)]
      if current_pos == end_pos
        return true unless board[*current_pos].color == color
      else
        return false unless board[*current_pos].empty?
      end
    end

    false
  end

  def change_multiplier(change)
    if change < 0
      -1
    elsif change > 0
      1
    else
      0
    end
  end
end
