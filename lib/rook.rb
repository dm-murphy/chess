# frozen_string_literal: true

# lib/chess_spec.rb

# Creates rook objects for Board class with coordinates, pieces, display style and possible moves
class Rook
  attr_accessor :coord, :pieces, :display, :possible_moves

  def initialize(coord, pieces)
    @coord = coord
    @pieces = pieces
    @display = "R"
    @possible_moves = []
    find_moves
  end

  def find_moves
    coord_changes = [[1, 0],
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
    
    coord_moves = coord_changes.map do |x, y|
      [@coord[0] + x, @coord[1] + y]
    end
    coord_moves.map do |x, y|
      @possible_moves.push([x, y]) if x.between?(0, 7) && y.between?(0,7)
    end
  end
end
