# frozen_string_literal: true

# lib/chess_spec.rb

# Creates knight objects for Board class with coordinates, pieces, display style and possible moves
class Knight
  attr_accessor :coord, :pieces, :display, :possible_moves

  def initialize(coord, pieces)
    @coord = coord
    @pieces = pieces
    @display = pieces == 'white' ? "\u{2658}" : "\u{265E}"
    @possible_moves = []
    find_moves
  end

  def find_moves
    coord_changes = [[1, 2],
                     [2, 1],
                     [2, -1],
                     [1, -2],
                     [-1, -2],
                     [-2, -1],
                     [-2, 1],
                     [-1, 2]]

    coord_moves = coord_changes.map do |x, y|
      [@coord[0] + x, @coord[1] + y]
    end
    coord_moves.map do |x, y|
      @possible_moves.push([x, y]) if x.between?(0, 7) && y.between?(0, 7)
    end
  end
end
