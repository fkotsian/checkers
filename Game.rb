# Game.rb
# Part of Checkers project
# Last Modified: 4/10/14
# By: Frank Kotsianas

require './Board.rb'
require './Piece.rb'

class Game
  attr_accessor :turn, :checkerboard

  def initialize
    @checkerboard = Board.new
    @turn = :red

    display_board
    play_game
  end

  def play_game
    until self.checkerboard.pieces_of_color(turn).empty?
      play_turn(self.turn)
      puts
      display_board
      puts
      switch_turns
    end

    puts "Game over! #{turn} has no pieces left. #{self.opposite_turn} wins!"
  end

  def play_turn(color)

    begin
      move_seq = []
      from = ""
      to = ""

      puts "#{turn}, enter your moves. (row, col), 'n' to stop: "
      puts "#{turn}, what piece do you want to move? "
      from = gets.chomp
      from = from.split(',').map(&:strip).map(&:to_i)

      puts "to? "
      to = gets.chomp
      to = to.split(',').map(&:strip).map(&:to_i)
      move_seq << to

      selected_piece = self.checkerboard[from]

      # see if was a jump, and exists another
      p selected_piece.has_valid_jumps?
      if made_jump?(from, to) && selected_piece.has_valid_jumps?

        loop do
          puts "Do you want to jump again? (Enter [row, col] or 'n' for 'No'.)"
          to = gets.chomp
          break if to == "n" || to.strip == ""
          to = to.split(',').map(&:strip).map(&:to_i)
          move_seq << to
        end

      end

      unless selected_piece.color != self.turn
        selected_piece.perform_moves( move_seq )
      else
        raise InvalidMoveError.new "That's not your piece!"
      end

    rescue => e #InvalidMoveError => e
      puts e
      retry
    end
    # rescue StandardError => e
    #   puts "Not a valid move input!"
    #   retry
  end

  def made_jump?(from, to)
    ( from.first - to.first ).abs > 1 || ( from.last - to.last ).abs > 1
  end

  def switch_turns
    self.turn = opposite_turn
  end

  def opposite_turn
    if self.turn == :red
      :black
    else
      :red
    end
  end

  def display_board
    self.checkerboard.display
  end
end

g = Game.new
