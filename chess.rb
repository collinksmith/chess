require 'byebug'
require_relative "lib/game"

def get_game_type
  question = <<-QUESTION
Which type of game do you want to play? Enter the number indicated on the left:
1 - Human vs Human
2 - White Human vs Black AI
3 - Black Human vs White AI
4 - AI vs AI
  QUESTION

  puts question
  gets.chomp.to_i
end

def setup_game(game_type)
  case game_type
  when 1
    player1 = HumanPlayer.new(:white)
    player2 = HumanPlayer.new(:black)
  when 2
    player1 = HumanPlayer.new(:white)
    player2 = ComputerPlayer.new(:black)
  when 3
    player1 = ComputerPlayer.new(:white)
    player2 = HumanPlayer.new(:black)
  when 4
    player1 = ComputerPlayer.new(:white)
    player2 = ComputerPlayer.new(:black)
  end
  Game.new(player1, player2)
end

if __FILE__ == $PROGRAM_NAME
  game_type = get_game_type
  game = setup_game(game_type)
  game.play
end