require_relative 'board'
require 'io/console'

class Game
  attr_reader :board

  def initialize
    @board = Board.new
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
    end
  end
end
