# Piece.rb
# Contains Piece class and InvalidMoveError class
# Part of Checkers project
# Last Modified: 4/10/14
# By: Frank Kotsianas

require "./Board.rb"

class Piece
  attr_accessor :pos, :board, :king, :color

  def initialize(position, brd, color)
    @pos = position
    @board = brd
    @color = color
    @king = false
  end

  def perform_moves(move_seq)
    if valid_move_seq?(move_seq)
      perform_moves!(move_seq)
    else
      raise InvalidMoveError.new "One or more of your moves are invalid!"
    end
  end

  def valid_move_seq?(move_seq)
    duped_board = self.board.dup
    duped_piece = duped_board[ self.pos ]

    begin
      duped_piece.perform_moves!(move_seq)
    rescue InvalidMoveError => e
      # puts e
      false
    else
      true
    end

  end

  def perform_moves!(move_seq)
    if move_seq.empty? || move_seq.nil?
      raise InvalidMoveError.new "No moves to make!"

    elsif move_seq.one?
      to = move_seq.first
      if perform_slide(to)
      elsif perform_jump(to)
      else
        raise InvalidMoveError.new "Can't move there!"
      end

    else    # is multiple moves long
      to = move_seq.first
      if perform_jump(to)
        perform_moves!( move_seq[1..-1] )
      end
    end
  end

  def perform_slide(pos)
    if valid_slides.include?(pos)
      #remove from the original spot
      curr_piece_loc = self.pos
      self.board[ curr_piece_loc ] = nil

      # update position and (optionally) add it to the new spot
      self.pos = pos
      self.board[ self.pos ] = self
      true
    else
      false
    end
  end

  def perform_jump(pos)
    if valid_jumps.include?(pos)
      # remove from the original spot
      start_piece_loc = self.pos
      self.board[ start_piece_loc ] = nil

      # remove jumped piece
      jumped_piece_loc = find_jumped_square(start_piece_loc, pos)
      self.board[ jumped_piece_loc ] = nil

      # update position and (optionally) add it to the new spot
      self.pos = pos
      self.board[ self.pos ] = self
      true
    else
      false
    end
  end

  def valid_slides
    diffs = move_diffs_in_direction
    diffs.map do |diff|
      new_pos = get_new_pos(diff)
      if self.board.empty?(new_pos) && within_boundaries?(new_pos)
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
      new_pos = get_new_pos( diff.map { |coord| coord * 2 } )
      if not self.board.empty?(possibly_occupied_pos) && within_boundaries?(new_pos)
        new_pos
      else
        nil
      end
    end
  end

  def has_valid_jumps?
    !self.valid_jumps.all?(&:nil?)
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

  def within_boundaries?(pos)
    pos_x, pos_y = pos
    ( pos_x.between?(0, self.board.grid.length) &&
      pos_y.between?(0, self.board.grid.first.length) )
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

  def dup(new_board)
    Piece.new( self.pos, new_board, self.color )
  end

end

class InvalidMoveError < StandardError; end