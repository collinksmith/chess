require_relative "lib/game"

if __FILE__ == $PROGRAM_NAME
  player1 = HumanPlayer.new(:white)
  player2 = ComputerPlayer.new(:black)
  g = Game.new(player1, player2)
  g.play
end
