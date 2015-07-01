require_relative 'pieces/bishop'
require_relative 'pieces/king'
require_relative 'pieces/knight'
require_relative 'pieces/pawn'
require_relative 'pieces/queen'
require_relative 'pieces/rook'
require_relative 'empty_square'
require 'colorize'

class Board
  attr_reader :selected_pos, :grid

  def initialize(player = :white, cursor_pos = [0, 0], selected_pos = nil)
    @cursor_pos = cursor_pos
    @selected_pos = selected_pos
    @current_player = player
  end

  def [](row, col)
    grid[row][col]
  end

  def []=(row, col, value)
    grid[row][col] = value
  end

  def move(start_pos = selected_pos, end_pos = cursor_pos)
    if self[*start_pos].valid_move?(end_pos)
      move!(start_pos, end_pos)
    else
      raise MoveError.new "Invalid move."
    end
  end

  def move!(start_pos = selected_pos, end_pos = cursor_pos)
    current_piece = self[*start_pos]
    self[*end_pos] = current_piece
    self[*start_pos] = EmptySquare.new
    current_piece.pos = end_pos
  end

  def switch_players!
    self.current_player = other_player
  end

  def reset_selected_pos
    self.selected_pos = nil
  end

  def set_selected_pos
    if self[*cursor_pos].color == current_player
      self.selected_pos = cursor_pos
      print "#{selected_pos}"
    end
  end

  def in_check?(color)
    king_piece = pieces(color).select { |piece| piece.king? }.first
    king_pos = king_piece.pos
    pieces(other_player).any? { |piece| piece.valid_move?(king_pos) }
  end

  def checkmate?(color)
    in_check?(color) && pieces(color).all? { |piece| piece.valid_moves.empty? }
  end

  def pieces(color)
    grid.flatten.select { |square| square.color == color }
  end

  def positions
    (0..7).map { |row| (0..7).map { |col| [row, col] } }.inject(&:+)
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

  def cursor_up
    if cursor_pos.first > 0
      new_pos = [cursor_pos.first - 1, cursor_pos.last]
      self.cursor_pos = new_pos
    end
  end

  def cursor_down
    if cursor_pos.first < 7
      new_pos = [cursor_pos.first + 1, cursor_pos.last]
      self.cursor_pos = new_pos
    end
  end

  def cursor_right
    if cursor_pos.last < 7
      new_pos = [cursor_pos.first, cursor_pos.last + 1]
      self.cursor_pos = new_pos
    end
  end

  def cursor_left
    if cursor_pos.last > 0
      new_pos = [cursor_pos.first, cursor_pos.last - 1]
      self.cursor_pos = new_pos
    end
  end

  def render
    puts output_string
  end

  def dup
    new_selected_pos = selected_pos ? selected_pos.dup : selected_pos
    new_board = Board.new(current_player, cursor_pos.dup, new_selected_pos)
    new_board.grid = grid.map { |row| row.map { |piece| piece.dup(new_board) } }
    new_board
  end

  def inspect
    nil
  end

  protected

  attr_writer :grid


  private

  attr_writer :selected_pos
  attr_accessor :current_player, :cursor_pos

  def other_player
    (current_player == :black) ? :white : :black
  end

  def output_string
    grid.map.with_index do |row, r_idx|
      row_string(row, r_idx)
    end.join("\n")
  end

  def row_string(row, r_idx)
    row.map.with_index do |cell, c_idx|
      selected_piece = selected_pos.nil? ? nil : self[*selected_pos]
      cursor_piece = self[*cursor_pos]

      if [r_idx, c_idx] == cursor_pos
        cell.to_s.colorize(background: :green)
      elsif selected_pos && selected_piece.valid_move?([r_idx, c_idx]) &&
            selected_piece.color == current_player
        cell.to_s.colorize(background: :yellow)
      elsif selected_pos.nil? && cursor_piece.valid_move?([r_idx, c_idx]) &&
            cursor_piece.color == current_player
        cell.to_s.colorize(background: :yellow)
      elsif (r_idx + c_idx) % 2 == 0
        cell.to_s.colorize(background: :light_red)
      else
        cell.to_s.colorize(background: :light_cyan)
      end
    end.join('')
  end

end
