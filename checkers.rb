# Checkers.rb
# App Academy W2D4, 4/10/14
# By: Frank Kotsianas

# Encoding: utf-8

class Piece
  attr_accessor :pos, :board, :king, :color

  def initialize(position, brd, color)
    @pos = position
    @board = brd
    @color = color
    @king = false
  end

  def perform_moves!(move_seq)

  end

  def perform_slide(pos)
    #remove from the original spot
    curr_piece_loc = self.pos
    self.board[ curr_piece_loc ] = nil

    # update position and (optionally) add it to the new spot
    self.pos = pos
    self.board[ self.pos ] = self
    self
  end

  def perform_jump(pos)
    # remove from the original spot
    start_piece_loc = self.pos
    self.board[ start_piece_loc ] = nil

    # remove jumped piece
    jumped_piece_loc = find_jumped_square(start_piece_loc, pos)
    self.board[ jumped_piece_loc ] = nil

    # update position and (optionally) add it to the new spot
    self.pos = pos
    self.board[ self.pos ] = self
    self
  end

  def valid_slides
    diffs = move_diffs_in_direction
    diffs.map do |diff|
      new_pos = get_new_pos(diff)
      if self.board.empty?(new_pos)
        new_pos
      else
        nil
      end
    end
  end

  def valid_jumps
    diffs = move_diffs_in_direction
    diffs.map do |diff|
      possibly_occupied_pos = get_new_pos(diff)
      if not self.board.empty?(possibly_occupied_pos)
        #generate new position
        get_new_pos( diff.map { |coord| coord * 2 } )
      else
        nil
      end
    end
  end

  def maybe_promote
    ( self.king = true ) if ( self.pos.first == 0 || self.pos.first == self.board.grid.length-1 )
  end

  def find_jumped_square(from, to)
    [ (from.first + to.first) / 2,
      (from.last  + to.last ) / 2   ]
  end

  def get_new_pos(diff)
    [ self.pos.first + diff.first,
      self.pos.last  + diff.last   ]
  end

  def move_diffs_in_direction
    dir = self.direction
    move_diffs.map { |diff| diff.map { |coord| coord * dir } }
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

  def direction
    if self.color == :red
      1
    else
      -1
    end
  end
end

class Board
  attr_accessor :grid

  def initialize(setup = true)
    @grid = Array.new(8) { Array.new(8) }

    setup_board if setup
    display
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

  def move_piece(from, to)
    # if from and to are 2 away
    curr_piece = self[from]
    if curr_piece.valid_slides.include?(to)
      p "Curr slide is: #{curr_piece.valid_slides.include?(to) }"
      # self[to] =
      curr_piece.perform_slide(to)

    elsif curr_piece.valid_jumps.include?(to)
      p "Curr jump is: #{curr_piece.valid_jumps.include?(to) }"
      # self[to] =
      curr_piece.perform_jump(to)

    else
      raise InvalidMoveError.new "Can't move there!"

    end
    curr_piece.maybe_promote
  end

  def place_piece(pos, piece)
    self[pos] = piece
  end

  def [](pos)
    pos_x, pos_y = pos
    self.grid[pos_x][pos_y]
  end

  def []=(pos, piece)
    raise "Invalid position" unless valid_pos?(pos)

    pos_x, pos_y = pos
    self.grid[pos_x][pos_y] = piece
  end

  def empty?(pos)
    pos_x, pos_y = pos
    self.grid[pos_x][pos_y].nil?
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
      # else
      #   self[ [row, col] ] = nil
      # end
    end
  end

  def valid_pos?(pos)
    pos.all? { |coord| coord.between?(0, self.grid.length) }
  end


end

class InvalidMoveError < StandardError
end

# class Game
#
#   def initialize
#     b = Board.new
#
#     play_turns
#   end
#
#   def play_turns
#     puts "Red, what piece do you want to move [row, col]"
#   end
#
# end

b = Board.new
b.move_piece( [2,1], [3,2] )
puts
b.display

b.move_piece( [5,0], [4,1] )
puts
b.display

b.move_piece( [3,2], [5,0] )
puts
b.display

# b.move_piece( [3,2] )
# puts
# b.display
#
# b.move_piece( [2,1], [3,2] )
# puts
# b.display
#
# b.move_piece( [2,1], [3,2] )
# puts
# b.display
#
#
#
#


















