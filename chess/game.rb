require_relative 'board'
require 'io/console'

class Game
  attr_reader :board
  attr_accessor :players

  def initialize
    @board = Board.new
    board.populate_grid
    @players = [:white, :black]
  end

  def play
    loop do
      render_board
      begin
        action = get_input
        break if action == 'q'
      rescue => e
        puts e.message
        switch_players!
        reset_selected_pos
        retry
      end

      if checkmate?(current_player)
        render_board
        puts "Checkmate! #{current_player.to_s.capitalize} player loses."
        break
      end
    end
  end

  def checkmate?(current_player)
    board.checkmate?(current_player)
  end

  def switch_players!
    players.reverse!
    board.current_player = current_player
  end

  def current_player
    players.first
  end

  def render_board
    system('clear')
    board.render

    unless checkmate?(current_player)
      puts "#{current_player.to_s.capitalize}'s turn"
      puts "Check" if board.in_check?(current_player)
    end
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
    if board[*board.cursor_pos].color == current_player
      board.selected_pos = board.cursor_pos
    end
  end

  def make_move
    switch_players!
    board.move
  end

end

g = Game.new
g.play
