class ComputerPlayer
  attr_reader :color
  attr_accessor :board

  def initialize(color)
    @color = color
    @board = nil
  end

  def choose_promotion
    "Q"
  end

  def make_move
    valid_move_array = valid_moves
    attack_move_array = attack_moves(valid_move_array)
    check_move_array = check_moves(valid_move_array)
    checkmate_move_array = checkmate_moves(check_move_array)

    if !checkmate_move_array.empty?
      make_checkmate_move(checkmate_move_array)
    elsif !check_move_array.empty?
      make_check_move(check_move_array)
    elsif !attack_move_array.empty?
      make_random_attack(attack_move_array)
    elsif !valid_move_array.empty?
      make_random_move(valid_move_array)
    else
      raise "No available moves"
    end
    
    true
  end

  def make_checkmate_move(checkmate_move_array)
    move = checkmate_move_array.sample
    board.move(move.first, move.last)
  end

  def make_check_move(check_move_array)
    move = check_move_array.sample
    board.move(move.first, move.last)
  end


  def make_random_move(valid_move_array)
    move = valid_move_array.sample
    board.move(move.first, move.last)
  end

  def make_random_attack(attack_move_array)
    move = attack_move_array.sample
    board.move(move.first, move.last)
  end

  def other_color
    color == :white ? :black : :white
  end

  def checkmate_moves(check_move_array)
    moves = []
    check_move_array.each do |start_pos, end_pos|
      new_board = board.dup
      new_board.move!(start_pos, end_pos)
      moves << [start_pos, end_pos] if new_board.checkmate?(other_color)
    end
    moves
  end

  def check_moves(valid_move_array)
    moves = []
    valid_move_array.each do |start_pos, end_pos|
      new_board = board.dup
      new_board.move!(start_pos, end_pos)
      moves << [start_pos, end_pos] if new_board.in_check?(other_color)
    end
    moves
  end

  def attack_moves(valid_move_array)
    valid_move_array.select { |_, end_pos| board[*end_pos].color == other_color }
  end

  def valid_moves
    moves = []
    pieces = board.pieces(color)
    pieces.each do |piece|
      piece.valid_moves.each do |end_pos|
        moves << [piece.pos, end_pos]
      end
    end
    moves
  end
end
