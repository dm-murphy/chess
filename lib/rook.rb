# frozen_string_literal: true

# Creates rook objects for Board class with coordinates, pieces, display style and possible moves
class Rook
  include Piece
  attr_accessor :coord, :pieces, :display, :possible_moves, :first_move

  def initialize(coord, pieces)
    @coord = coord
    @pieces = pieces
    @display = pieces == 'white' ? "\u{2656}" : "\u{265C}"
    @possible_moves = []
    @first_move = []
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
     [0, -7]]
  end

  def next_space_moves
    [[1, 0],
     [-1, 0],
     [0, 1],
     [0, -1]]
  end
end
