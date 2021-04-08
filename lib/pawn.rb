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

  def find_possible_moves
    coord_changes = find_piece_moves

    coord_moves = coord_changes.map do |x, y|
      [@coord[0] + x, @coord[1] + y]
    end
    coord_moves.map do |x, y|
      @possible_moves.push([x, y]) if x.between?(0, 7) && y.between?(0, 7)
    end
  end

  def find_piece_moves
    forward_moves + diagonal_attacks
  end

  def forward_moves
    if @pieces == 'white'
      array = [[1, 0]]
      array.push([2, 0]) if @first_move.empty?
    else
      array = [[-1, 0]]
      array.push([-2, 0]) if @first_move.empty?
    end
    array
  end

  def diagonal_attacks
    if @pieces == 'white'
      [[1, 1], [1, -1]]
    else
      [[-1, 1], [-1, -1]]
    end
  end

  def next_space_moves
    find_piece_moves
  end

  # En passant?

  # Promotion?
end
