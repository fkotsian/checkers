# Checkers.rb
# App Academy W2D4, 4/10/14
# By: Frank Kotsianas

# Encoding: utf-8

class Piece
  attr_accessor :pos, :king, :direction

  def initialize(position, dir = nil)
    @king = false
    @pos = position
    @direction = dir || set_direction
  end

  def perform_slide
    #get move_diffs, times :direction
    #maybe_promote
  end

  def perform_jump
    #if piece in slide_diffs
    #move to slide_diffs * 2 and
      #remove that piece
    #maybe_promote
  end

  def move_diffs
    if king
      [
        [ 1, -1],
        [ 1,  1],
        [-1, -1],
        [-1,  1]
      ]
    else
      [
        [ 1, -1],
        [ 1,  1]
      ]
    end
  end

  def set_direction
    if self.position.first < 4
      1
    else
      -1
    end
  end
end

class Board
  attr_accessor :grid

  def initialize(setup)
    @grid = Array.new(8) { Array.new(8, nil) }

    setup_board if setup
  end

  def [](pos)
    pos_x, pos_y = pos
    self.grid[pos_x][pos_y]
  end

  def setup_board
    (0..2).each do |row|
      place_row(row)
    end

    (5..7).each do |row|
      place_row(row)
    end
  end

  def place_row(row)
    ( 0...(self.grid[row].length / 2) )
          .map { |el| el * 2 }.each do |col|
      col += 1 if row.even?
      self[ [row, col] ] = Piece.new([row, col])
    end
  end

  def valid_pos?(pos)
    pos.all? { |coord| coord.between?(0, self.grid.length) }
  end

  protected
  def []=(pos, piece)
    raise "Invalid position" unless valid_pos?(pos)

    pos_x, pos_y = pos
    self.grid[pos_x][pos_y] = piece
  end

end































