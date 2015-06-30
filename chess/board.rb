require_relative 'piece'
require_relative 'empty_square'
require 'colorize'
require 'byebug'

class Board
  attr_reader :grid
  attr_accessor :cursor_pos

  def initialize
    @grid = populate_grid
    @cursor_pos = [0, 0]
  end

  def populate_grid
    grid = Array.new(8)
    grid[0], grid[7] = other_piece_row(:black), other_piece_row(:white)
    grid[1], grid[6] = pawn_row(:black), pawn_row(:white)
    2.upto(5) { |row| grid[row] = empty_row }
    grid
  end

  def empty_row
    Array.new(8) { EmptySquare.new }
  end

  def pawn_row(color)
    Array.new(8) { Pawn.new(color) }
  end

  def other_piece_row(color)
    row = Array.new(8)
    row[0], row[7] = Rook.new(color), Rook.new(color)
    row[1], row[6] = Knight.new(color), Knight.new(color)
    row[2], row[5] = Bishop.new(color), Bishop.new(color)
    row[3], row[4] = Queen.new(color), King.new(color)
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


end
