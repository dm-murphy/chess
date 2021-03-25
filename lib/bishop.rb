# frozen_string_literal: true

# lib/chess_spec.rb

# Creates bishop objects for Board class with coordinates, pieces, display style and possible moves
class Bishop
  attr_accessor :coord, :pieces, :display, :possible_moves

  def initialize(coord, pieces)
    @coord = coord
    @pieces = pieces
    @display = pieces == 'white' ? "\u{2657}" : "\u{265D}"
    @possible_moves = []
    find_possible_moves
  end

  def find_possible_moves
    coord_changes = [[1, 1],
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

    coord_moves = coord_changes.map do |x, y|
      [@coord[0] + x, @coord[1] + y]
    end
    coord_moves.map do |x, y|
      @possible_moves.push([x, y]) if x.between?(0, 7) && y.between?(0, 7)
    end
  end

  def next_space_moves
    [[1, 1],
     [1, -1],
     [-1, 1],
     [-1, -1]]
  end
end
