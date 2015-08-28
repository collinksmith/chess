require_relative 'slideable'

module Straightable
  include Slideable

  def valid_straight?(end_pos)
    return false if pos == end_pos

    row_change = end_pos[0] - pos[0]
    col_change = end_pos[1] - pos[1]
    return false unless row_change == 0 || col_change == 0

    valid_slide?(row_change, col_change, end_pos)
  end
end
