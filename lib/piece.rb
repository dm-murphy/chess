# frozen_string_literal: true

# Methods to find possible moves for piece classes
module Piece

  def find_possible_moves
    coord_moves = coord_changes.map do |x, y|
      [@coord[0] + x, @coord[1] + y]
    end
    coord_moves.map do |x, y|
      @possible_moves.push([x, y]) if valid_coordinate?(x, y)
    end
  end

  def valid_coordinate?(x_coord, y_coord)
    x_coord.between?(0, 7) && y_coord.between?(0, 7)
  end
end
