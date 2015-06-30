require_relative 'board'
require 'io/console'

class Game
  attr_reader :board

  def initialize
    @board = Board.new
    @board.populate_grid
  end

  def play
    loop do
      system('clear')
      render_board
      action = get_input
      break if action == 'q'
    end
  end

  def render_board
    board.render
  end

  def get_input
    action = $stdin.getch

    case action
    when 'q'
      'q'
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
        make_move
        reset_selected_pos
      end
    end
  end

  def reset_selected_pos
    board.selected_pos = nil
  end

  def set_selected_pos
    board.selected_pos = board.cursor_pos
  end

  def make_move
    board.move
    rescue => e
      puts e.message
  end

end

g = Game.new
g.play
