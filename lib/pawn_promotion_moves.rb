# frozen_string_literal: true

# lib/chess_spec.rb

# Responsible for providing pawn promotion moves to MoveGenerator class
class PawnPromotionMoves < MoveGenerator

  def check_pawn_promotion(origin_piece, destination_coord, start_coord)
    return unless origin_piece.class == Pawn
    return unless destination_coord.first == 7 || destination_coord.first == 0

    promote_pawn(origin_piece, start_coord)
  end

  def promote_pawn(origin_piece, start_coord)
    display_pawn_promotion
    piece_selection_number = @current_player.select_promotion.to_i
    promoted_piece_name = find_piece_class(piece_selection_number)
    pieces = origin_piece.pieces
    @board.promote_pawn(promoted_piece_name, start_coord, pieces)
  end

  def display_pawn_promotion
    puts 'Pawn promoted. Select piece for pawn promotion:'
    puts '1 = Queen'
    puts '2 = Knight'
    puts '3 = Rook'
    puts '4 = Bishop'
  end

  def find_piece_class(piece_selection_number)
    hash = { 'Queen' => 1, 'Knight' => 2, 'Rook' => 3, 'Bishop' => 4 }
    hash.key(piece_selection_number)
  end
end
