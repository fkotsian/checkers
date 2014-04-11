# Board.rb
# Part of Checkers project
# Last Modified: 4/10/14
# By: Frank Kotsianas

load "Piece.rb"

class Board
  attr_accessor :grid

  def initialize(setup = true)
    @grid = Array.new(8) { Array.new(8) }

    setup_board if setup
  end

  def display
    (0...self.grid.length).each do |row|
      print "#{row} "
      (0...self.grid.first.length).each do |col|
        curr_pos = [row, col]
        if empty?( curr_pos )
          print "_ "
        else
          print "r " if self[curr_pos].color ==  :red
          print "b " if self[curr_pos].color ==  :black
        end
      end
      puts
    end
    puts "  0 1 2 3 4 5 6 7"
  end

  def place_piece(pos, piece)
    self[pos] = piece
  end

  def [](pos)
    pos_x, pos_y = pos
    self.grid[pos_x][pos_y]
  end

  def []=(pos, piece)
    raise InvalidMoveError.new "Invalid position" unless valid_pos?(pos)

    pos_x, pos_y = pos
    self.grid[pos_x][pos_y] = piece
  end

  def empty?(pos)
    pos_x, pos_y = pos
    self.grid[pos_x][pos_y].nil?
  end

  def dup
    new_board = Board.new(false)

    for piece in self.pieces
      duped_piece = piece.dup(new_board)
      new_board[duped_piece.pos] = duped_piece
    end
    new_board
  end

  def pieces_of_color(color)
    self.pieces.select { |piece| piece.color == color }
  end

  def pieces
    self.grid.flatten.compact
  end

  protected
  def setup_board
    (0..2).each do |row|
      place_row(row, :red)
    end

    (5..7).each do |row|
      place_row(row, :black)
    end
  end

  def place_row(row, color)
    (0...self.grid[row].length).select(&:even?).each do |col|
      col += 1 if row.even?
      curr_pos = [row, col]

      new_piece = Piece.new(curr_pos, self, color)
      place_piece(curr_pos, new_piece)
    end
  end

  def valid_pos?(pos)
    pos.all? { |coord| coord.between?(0, self.grid.length) }
  end
end
