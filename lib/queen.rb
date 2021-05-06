# frozen_string_literal: true

# lib/chess_spec.rb

# Creates queen objects for Board class with coordinates, pieces, display style and possible moves
class Queen
  include Piece

  attr_accessor :coord, :pieces, :display, :possible_moves

  def initialize(coord, pieces)
    @coord = coord
    @pieces = pieces
    @display = pieces == 'white' ? "\u{2655}" : "\u{265B}"
    @possible_moves = []
    find_possible_moves
  end

  def coord_changes
    [[1, 0],
     [2, 0],
     [3, 0],
     [4, 0],
     [5, 0],
     [6, 0],
     [7, 0],
     [-1, 0],
     [-2, 0],
     [-3, 0],
     [-4, 0],
     [-5, 0],
     [-6, 0],
     [-7, 0],
     [0, 1],
     [0, 2],
     [0, 3],
     [0, 4],
     [0, 5],
     [0, 6],
     [0, 7],
     [0, -1],
     [0, -2],
     [0, -3],
     [0, -4],
     [0, -5],
     [0, -6],
     [0, -7],
     [1, 1],
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
    [[1, 0],
     [1, 1],
     [1, -1],
     [-1, 0],
     [-1, 1],
     [-1, -1],
     [0, 1],
     [0, -1]]
  end
end
