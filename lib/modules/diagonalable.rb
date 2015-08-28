require_relative 'slideable'

module Diagonalable
  include Slideable

  def valid_diagonal?(end_pos)
    return false if pos == end_pos

    row_change = end_pos[0] - pos[0]
    col_change = end_pos[1] - pos[1]
    return false if row_change.abs != col_change.abs

    valid_slide?(row_change, col_change, end_pos)
  end
end
