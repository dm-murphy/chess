# frozen_string_literal: true

# lib/chess_spec.rb

# Creates rook objects for Board class with coordinates, pieces, display style and possible moves
class Rook
  attr_accessor :coord, :pieces, :display, :possible_moves, :single_moves, :first_move

  def initialize(coord, pieces)
    @coord = coord
    @pieces = pieces
    @display = pieces == 'white' ? "\u{2656}" : "\u{265C}"
    @possible_moves = []
    @single_moves = []
    @first_move = []
    find_possible_moves
    find_single_moves
  end

  def find_possible_moves
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
      @possible_moves.push([x, y]) if x.between?(0, 7) && y.between?(0, 7)
    end
  end

  def next_space_moves
    [[1, 0],
     [-1, 0],
     [0, 1],
     [0, -1]]
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
