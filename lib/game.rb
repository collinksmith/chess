require_relative 'board'
require_relative 'players/human_player'
require_relative 'players/computer_player'
require 'io/console'

class Game
  attr_reader :board
  attr_accessor :players

  def initialize(player1, player2)
    @board = Board.new
    board.populate_grid
    @players = [player1, player2]
    @players.each { |player| player.board = board }
  end

  def play
    until checkmate?
      get_move
      switch_players!
    end
    render_board
  end

  private

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
    board.switch_players!
  end

  def current_player
    players.first
  end

  def render_board
    system('clear')
    board.display

    if checkmate?
      puts "Checkmate! #{current_player.color.to_s.capitalize} player loses."
    else
      puts "#{current_player.color.to_s.capitalize}'s turn"
      puts "Check" if board.in_check?(current_player.color)
    end

    sleep(1) if players.all? { |player| player.is_a?(ComputerPlayer) }
  end
end

if __FILE__ == $PROGRAM_NAME
  player1 = HumanPlayer.new(:white)
  player2 = ComputerPlayer.new(:black)
  game = Game.new(player1, player2)
  game.play
end

