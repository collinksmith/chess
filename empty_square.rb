class EmptySquare
  
  def to_s
    '   '
  end

  def empty?
    true
  end

  def color
    nil
  end

  def valid_move?(end_pos)
    false
  end

  def dup(board)
    EmptySquare.new
  end

  def king?
    false
  end

end
