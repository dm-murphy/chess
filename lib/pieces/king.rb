# frozen_string_literal: true

# lib/chess_spec.rb

# Creates king objects for Board class with coordinates, pieces, display style and possible moves
class King
  include Piece

  attr_accessor :coord, :pieces, :display, :possible_moves, :first_move

  def initialize(coord, pieces)
    @coord = coord
    @pieces = pieces
    @display = pieces == 'white' ? "\u{2654}" : "\u{265A}"
    @possible_moves = []
    @first_move = []
    find_possible_moves
  end

  def coord_changes
    [[1, 0],
     [1, 1],
     [1, -1],
     [0, 1],
     [0, -1],
     [-1, 0],
     [-1, 1],
     [-1, -1]]
  end

  def next_space_moves
    [[1, 0],
     [1, 1],
     [1, -1],
     [0, 1],
     [0, -1],
     [-1, 0],
     [-1, 1],
     [-1, -1]]
  end
end
