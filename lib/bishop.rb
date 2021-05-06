# frozen_string_literal: true

# lib/chess_spec.rb

# Creates bishop objects for Board class with coordinates, pieces, display style and possible moves
class Bishop
  include Piece

  attr_accessor :coord, :pieces, :display, :possible_moves

  def initialize(coord, pieces)
    @coord = coord
    @pieces = pieces
    @display = pieces == 'white' ? "\u{2657}" : "\u{265D}"
    @possible_moves = []
    find_possible_moves
  end

  def coord_changes
    [[1, 1],
     [2, 2],
     [3, 3],
     [4, 4],
     [5, 5],
     [6, 6],
     [7, 7],
     [-1, -1],
     [-2, -2],
     [-3, -3],
     [-4, -4],
     [-5, -5],
     [-6, -6],
     [-7, -7],
     [-1, 1],
     [-2, 2],
     [-3, 3],
     [-4, 4],
     [-5, 5],
     [-6, 6],
     [-7, 7],
     [1, -1],
     [2, -2],
     [3, -3],
     [4, -4],
     [5, -5],
     [6, -6],
     [7, -7]]
  end

  def next_space_moves
    [[1, 1],
     [1, -1],
     [-1, 1],
     [-1, -1]]
  end
end
