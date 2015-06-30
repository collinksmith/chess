require_relative 'piece'
require_relative 'empty_square'
require 'colorize'
require 'byebug'

class Board
  attr_accessor :cursor_pos, :grid, :selected_pos

  def initialize
    @cursor_pos = [0, 0]
    @selected_pos = nil
  end

  def [](row, col)
    grid[row][col]
  end

  def []=(row, col, value)
    grid[row][col] = value
  end

  def move
    if self[*selected_pos].valid_move?(cursor_pos)
      current_piece = self[*selected_pos]
      self[*cursor_pos] = current_piece
      self[*selected_pos] = EmptySquare.new
      current_piece.pos = cursor_pos
    else
      raise "Invalid move."
    end
  end

  def in_check?(color)
    king_pos = pieces(color).select { |piece| piece.king? }.first.pos
    opponent_color = (color == :black) ? :white : :black
    pieces(opponent_color).any? { |piece| piece.valid_move?(king_pos) }
  end

  def pieces(color)
    pieces = []
    grid.each do |row|
      row.each do |piece|
        pieces << piece unless piece.empty? && piece.color == color
      end
    end
    pieces
  end

  def populate_grid
    grid = Array.new(8)
    grid[0], grid[7] = other_piece_row(:black, 0), other_piece_row(:white, 7)
    grid[1], grid[6] = pawn_row(:black, 1), pawn_row(:white, 6)
    2.upto(5) { |row| grid[row] = empty_row }
    @grid = grid
  end

  def empty_row
    Array.new(8) { EmptySquare.new }
  end

  def pawn_row(color, row)
    array = []
    8.times { |col| array << Pawn.new(color, self, [row, col])}
    array
  end

  def other_piece_row(color, row_idx)
    row = Array.new(8)
    row[0] = Rook.new(color, self, [row_idx, 0])
    row[7] = Rook.new(color, self, [row_idx, 7])
    row[1] = Knight.new(color, self, [row_idx, 1])
    row[6] = Knight.new(color, self, [row_idx, 6])
    row[2] = Bishop.new(color, self, [row_idx, 2])
    row[5] = Bishop.new(color, self, [row_idx, 5])
    row[3] = Queen.new(color, self, [row_idx, 3])
    row[4] = King.new(color, self, [row_idx, 4])
    row
  end

  def render
    puts output_string
  end

  def output_string
    grid.map.with_index do |row, r_index|
      row.map.with_index do |cell, c_index|
        if [r_index, c_index] == cursor_pos
          cell.to_s.colorize(background: :green)
        elsif !selected_pos.nil? && self[*selected_pos].valid_move?([r_index, c_index])
          cell.to_s.colorize(background: :yellow)
        elsif selected_pos.nil? && self[*cursor_pos].valid_move?([r_index, c_index])
          cell.to_s.colorize(background: :yellow)
        elsif (r_index + c_index) % 2 == 0
          cell.to_s.colorize(background: :light_red)
        else
          cell.to_s.colorize(background: :light_cyan)
        end
      end.join('')
    end.join("\n")
  end

  def cursor_up
    if cursor_pos.first > 0
      new_pos = [cursor_pos.first - 1, cursor_pos.last]
      @cursor_pos = new_pos
    end
  end

  def cursor_down
    if cursor_pos.first < 7
      new_pos = [cursor_pos.first + 1, cursor_pos.last]
      @cursor_pos = new_pos
    end
  end

  def cursor_right
    if cursor_pos.last < 7
      new_pos = [cursor_pos.first, cursor_pos.last + 1]
      @cursor_pos = new_pos
    end
  end

  def cursor_left
    if cursor_pos.last > 0
      new_pos = [cursor_pos.first, cursor_pos.last - 1]
      @cursor_pos = new_pos
    end
  end

  def inspect
    nil
  end

  def dup
    new_board = Board.new
    new_board.cursor_pos = cursor_pos
    new_board.selected_pos = selected_pos
    new_board.grid = grid.map { |row| row.map { |piece| piece.dup(new_board) }}
    new_board
  end

end
