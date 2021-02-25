# frozen_string_literal: true


# Creates king objects for Board class with coordinates, pieces, display style and possible moves
class King
  attr_accessor :coord, :pieces, :display, :possible_moves, :children, :parent, :single_moves, :first_move

  def initialize(coord, pieces)
    @coord = coord
    @pieces = pieces
    @display = pieces == 'white' ? "\u{2654}" : "\u{265A}"
    @possible_moves = []
    @single_moves = []
    @children = []
    @parent = nil
    find_possible_moves
    find_single_moves

    @first_move = []
  end

  def find_possible_moves
    coord_changes = [[1, 0],
                     [1, 1],
                     [1, -1],
                     [0, 1],
                     [0, -1],
                     [-1, 0],
                     [-1, 1],
                     [-1, -1]]

    coord_moves = coord_changes.map do |x, y|
      [@coord[0] + x, @coord[1] + y]
    end
    coord_moves.map do |x, y|
      @possible_moves.push([x, y]) if x.between?(0, 7) && y.between?(0,7)
    end
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

  def find_single_moves
    coord_changes = next_space_moves

    coord_moves = coord_changes.map do |x, y|
      [@coord[0] + x, @coord[1] + y]
    end
    coord_moves.map do |x, y|
      @single_moves.push([x, y]) if x.between?(0, 7) && y.between?(0, 7)
    end
  end
end