module Stepable
  def valid_move?(end_pos)
    row_change = end_pos[0] - pos[0]
    col_change = end_pos[1] - pos[1]

    return false unless self.class::MOVE_DIFFS.include?([row_change, col_change])
    return false if board[*end_pos].color == color

    !moves_into_check?(end_pos)
  end
end
