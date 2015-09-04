# Chess

This is a command line ruby implementation of chess. It has a simple AI and can be played human vs human, human vs AI, or AI vs AI.

## How to Use

### Running the program

You will need Ruby installed on your system.

Download the code, navigate to the main directory, and run `bundle install`. Then run chess.rb with your ruby interpreter (i.e. type `ruby chess.rb` in the terminal). You will be prompted to select the type of game you want to play.

### Playing the game

Move your cursor with the wasd keys. To move a piece, bring the cursor to its position and press enter to select it. Then move the cursor to another position and presss enter again to move it. To deselect a selected piece, press enter with the cursor over any invalid move position.

Valid move positions are highlighed in yellow.

![chess](/assets/images/chess.png)

To quit the game, press q when it is your turn. When viewing an AI vs AI game, press ctrl+c to abort the program.

## Technologies

This game was built from scratch with Ruby. It uses the [colorize][colorize] gem to color the board on the command line, and the [io-console][io] gem to enable use of $stdin.getch.

[colorize]: https://github.com/fazibear/colorize
[io]: https://rubygems.org/gems/io-console/versions/0.4.2

## Implementation Details

### Modules

To determine valid moves, pieces include one or more of the "stepable," "straightable," or "diagonalable" modules. Shared functionality between the straightable and diagonalable modules is factored out into a separate "slideable" module.

### Null Object Pattern

The board uses the null object pattern for empty squares, allowing it to call piece methods on all squares, even if they are empty. For example, calling `valid_move?` on an empty square will return `false` rather than raise an error.

### Deep Dup

The board has a custom `dup` method, which returns a deep copy of the board. This is used to test whether a move will leave a player in check. It is also used by the AI to test possible moves.

### AI

This game has a simple AI implementation, with the following basic logic:

  * If a move that checkmates the opponent is available, make it.
  * Otherwise, if a move that puts the opponent is check is available, make it.
  * Otherwise, if a move that takes an opposing piece is available, make it.
  * Otherwise, make a random move.

At each step, if there is more than one option available, one is chosen at random.

## TODO

  * En Passant
  * Saving and loading games
  * Improve AI
