require_relative 'errors'

class HumanPlayer
  attr_reader :color
  attr_accessor :board

  def initialize(color)
    @color = color
    @board = nil
  end

  def make_move
    begin
      action = $stdin.getch
      moved = process_input(action)
    rescue MoveError => e
      puts e.message
      reset_selected_pos
      retry
    end

    moved
  end

  def process_input(action)
    case action
    when 'q'
      exit
    when 'w'
      board.cursor_up
    when 'a'
      board.cursor_left
    when 's'
      board.cursor_down
    when 'd'
      board.cursor_right
    when "\r"
      if board.selected_pos.nil?
        set_selected_pos
      else
        board.move
        reset_selected_pos
        return true
      end
    end

    false
  end

  def reset_selected_pos
    board.selected_pos = nil
  end

  def set_selected_pos
    if board[*board.cursor_pos].color == color
      board.selected_pos = board.cursor_pos
    end
  end


end
