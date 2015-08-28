require 'byebug'
require_relative "lib/game"

def get_game_type
  question = <<-QUESTION
Which type of game do you want to play? Enter the number indicated on the left: (Default is 2)
1 - Human vs Human
2 - White Human vs Black AI
3 - Black Human vs White AI
4 - AI vs AI
  QUESTION

  puts question
  game_type = gets.chomp
  game_type == "" ? 2 : game_type.to_i
end

def get_sleep_time
  puts "How long do you want to wait between turns? (Enter a number of seconds. Deault is 0.5)"
  sleep_time = gets.chomp
  sleep_time == "" ? 0.5 : sleep_time.to_f
end

def setup_game(game_type, sleep_time)
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

  Game.new(player1, player2, sleep_time)
end

if __FILE__ == $PROGRAM_NAME
  game_type = get_game_type
  sleep_time = game_type == 4 ? get_sleep_time : nil
  game = setup_game(game_type, sleep_time)
  game.play
end