# frozen_string_literal: true


# Creates pawn objects for Board class with coordinates, pieces, display style and possible moves
class Pawn
  attr_accessor :coord, :pieces, :display, :possible_moves, :first_move

  def initialize(coord, pieces)
    @coord = coord
    @pieces = pieces
    @display = pieces == 'white' ? "\u{2659}" : "\u{265F}"
    @possible_moves = []
    @first_move = []
    find_possible_moves
  end

  def find_regular_moves
    if @pieces == 'white'
      find_white_moves
    else
      find_black_moves
    end
  end

  def find_possible_moves
    coord_changes = find_regular_moves

    coord_moves = coord_changes.map do |x, y|
      [@coord[0] + x, @coord[1] + y]
    end
    coord_moves.map do |x, y|
      @possible_moves.push([x, y]) if x.between?(0, 7) && y.between?(0, 7)
    end
  end

  def find_white_moves
    array = [[1, 0]]
    array.push([2, 0]) if @first_move == []
  end

  def find_black_moves
    array = [[-1, 0]]
    array.push([-2, 0]) if @first_move == []
  end

  # Find possible attacks?

  # Regular move cannot swap out an opponent piece

  # En passant?

  # Promotion?

  def next_space_moves
    find_regular_moves
  end
end