class Piece
  attr_reader :icon

  def initialize(color)
    @color = color
  end

  def to_s
    " #{icon.to_s} "
  end

end

class Pawn < Piece

  def initialize(color)
    super(color)
    @icon = color == :black ? "\u265F".black : "\u265F"
  end

end

class Rook < Piece

  def initialize(color)
    super(color)
    @icon = color == :black ? "\u265C".black : "\u265C"
  end

end

class Bishop < Piece

  def initialize(color)
    super(color)
    @icon = color == :black ? "\u265D".black : "\u265D"
  end

end

class Knight < Piece

  def initialize(color)
    super(color)
    @icon = color == :black ? "\u265E".black : "\u265E"
  end

end

class Queen < Piece

  def initialize(color)
    super(color)
    @icon = color == :black ? "\u265B".black : "\u265B"
  end

end

class King < Piece

  def initialize(color)
    super(color)
    @icon = color == :black ? "\u265A".black : "\u265A"
  end

end
