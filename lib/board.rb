require_relative 'empty_square'
require_relative 'pieces/bishop'
require_relative 'pieces/king'
require_relative 'pieces/knight'
require_relative 'pieces/pawn'
require_relative 'pieces/piece'
require_relative 'pieces/queen'
require_relative 'pieces/rook'
require 'colorize'

class Board
  attr_reader :selected_pos, :grid

  def initialize(player = :white, cursor_pos = [6, 4], selected_pos = nil)
    @cursor_pos = cursor_pos
    @selected_pos = selected_pos
    @current_player = player
    @promotion_piece = nil
  end

  def [](row, col)
    grid[row][col]
  end

  def []=(row, col, value)
    grid[row][col] = value
  end

  def move(start_pos = selected_pos, end_pos = cursor_pos)
    piece = self[*start_pos]

    if piece.valid_move?(end_pos)
      if piece.king? && piece.valid_castle?(end_pos)
        castle!
      else
        move!(start_pos, end_pos)
      end
    else
      raise_move_error(piece, end_pos)
    end
  end

  def move!(start_pos = selected_pos, end_pos = cursor_pos)
    current_piece = self[*start_pos]
    self[*end_pos] = current_piece
    self[*start_pos] = EmptySquare.new
    current_piece.pos = end_pos
    current_piece.moved = true

    promotion_piece = current_piece if current_piece.can_promote?
  end

  def promote!(choice)
    color = promotion_piece.color
    pos = promotion_piece.pos
    case choice
    when 'Q'
      new_piece = Queen.new(color, self, pos)
    when 'N'
      new_piece = Knight.new(color, self, pos)
    when 'R'
      new_piece = Rook.new(color, self, pos)
    when 'B'
      new_piece = Bishop.new(color, self, pos)
    when 'P'
      new_piece = Pawn.new(color, self, pos)
    end
  end

  def castle!(start_pos = selected_pos, end_pos = cursor_pos)
    move!(start_pos, end_pos)
    dir = end_pos[1] > 4 ? 1 : -1
    rook_pos = dir > 0 ? [end_pos[0], 7] : [end_pos[0], 0]
    rook = self[*rook_pos]
    end_rook_pos = [end_pos[0], end_pos[1] - dir]
    self[*end_rook_pos] = rook
    self[*rook_pos] = EmptySquare.new
    rook.pos = end_rook_pos
    rook.moved = true
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
    end
  end

  def in_check?(color)
    other_player = color == :white ? :black : :white

    king_piece = pieces(color).select { |piece| piece.king? }.first
    begin
      king_pos = king_piece.pos
    rescue => e
      puts e.message
    end
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
    grid[0], grid[7] = other_piece_row(:black), other_piece_row(:white)
    grid[1], grid[6] = pawn_row(:black), pawn_row(:white)
    2.upto(5) { |row| grid[row] = empty_row }
    @grid = grid
  end

  def empty_row
    Array.new(8) { EmptySquare.new }
  end

  def pawn_row(color)
    row_idx = color == :white ? 6 : 1

    (0..7).map { |col| Pawn.new(color, self, [row_idx, col]) }
  end

  def other_piece_row(color)
    row_idx = color == :white ? 7 : 0
    new_pieces = [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]

    new_pieces.map.with_index do |piece, col_idx|
      piece.new(color, self, [row_idx, col_idx])
    end
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

  def display
    puts render
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
  attr_accessor :current_player, :cursor_pos, :promotion_piece

  def raise_move_error(piece, end_pos)
    if piece.moves_into_check?(end_pos)
      raise MoveError.new "Can't make a move that leaves you in check."
    else
      raise MoveError.new "Invalid move."
    end
  end

  def other_player
    (current_player == :black) ? :white : :black
  end

  def render
    grid.map.with_index do |row, r_idx|
      render_row(row, r_idx)
    end.join("\n")
  end

  def render_row(row, r_idx)
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
