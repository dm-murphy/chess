# frozen_string_literal: true

# lib/chess_spec.rb

# Creates knight objects for Board class with coordinates, pieces, display style and possible moves
class Knight
  include Piece

  attr_accessor :coord, :pieces, :display, :possible_moves

  def initialize(coord, pieces)
    @coord = coord
    @pieces = pieces
    @display = pieces == 'white' ? "\u{2658}" : "\u{265E}"
    @possible_moves = []
    find_possible_moves
  end

  def coord_changes
    [[1, 2],
     [2, 1],
     [2, -1],
     [1, -2],
     [-1, -2],
     [-2, -1],
     [-2, 1],
     [-1, 2]]
  end

  def next_space_moves
    [[1, 2],
     [2, 1],
     [2, -1],
     [1, -2],
     [-1, -2],
     [-2, -1],
     [-2, 1],
     [-1, 2]]
  end
end
