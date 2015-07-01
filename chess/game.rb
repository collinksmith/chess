require_relative 'board'
require_relative 'human_player'
require 'io/console'

class Game
  attr_reader :board
  attr_accessor :players

  def initialize(player1, player2)
    @board = Board.new
    board.populate_grid
    @players = [player1, player2]
    @players.each { |player| player.board = board}
  end

  def play
    until checkmate?
      get_move
      switch_players!
    end
    render_board
  end

  def get_move
    moved = false
    until moved
      render_board
      moved = current_player.make_move
    end
  end

  def checkmate?
    board.checkmate?(current_player.color)
  end

  def switch_players!
    players.reverse!
    board.current_player = current_player.color
  end

  def current_player
    players.first
  end

  def render_board
    system('clear')
    board.render

    if checkmate?
      puts "Checkmate! #{current_player.to_s.capitalize} player loses."
    else
      puts "#{current_player.color.to_s.capitalize}'s turn"
      puts "Check" if board.in_check?(current_player.color)
    end
  end

end

player1 = HumanPlayer.new(:white)
player2 = HumanPlayer.new(:black)
g = Game.new(player1, player2)
g.play
