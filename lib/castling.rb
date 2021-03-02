# frozen_string_literal: true

# lib/chess_spec.rb

class Castling < Game
  attr_accessor :castle_destination

  def initialize(board, current_player)#, origin_piece)#, legal_moves)
    @board = board
    @current_player = current_player
    #@origin_piece = origin_piece
    #@legal_moves = legal_moves
    @castle_destination = []
  end

  def test_method
    p @origin_piece
    @castle_destination.push([1, 5])
  end

  def castle(origin_piece, legal_moves)
    return unless piece_is_king?(origin_piece)
    return unless origin_piece.first_move.empty?

    king_side_castle(origin_piece, legal_moves)
    # queen_side_castle(origin_piece, legal_moves, castle_destination)
  end

  # def queen_side_castle(origin_piece, legal_moves, castle_destination)
  #   rook = find_queen_side_rook
  #   return unless rook.first_move.empty?

  #   path = find_queen_side_path
  #   return if blocked_path?(path)

  #   path.pop
  #   check_path = path.push(origin_piece.coord)
  #   return if path_in_check?(check_path)

  #   if origin_piece.pieces == 'white'
  #     legal_moves.push([0, 2])
  #     castle_destination.push([0, 2])
  #   else
  #     legal_moves.push([7, 2])
  #     castle_destination.push([7, 2])
  #   end
  # end

  # def find_queen_side_rook
  #   find_king.pieces == 'white' ? @board.white_queen_side_rook : @board.black_queen_side_rook
  # end

  # def find_queen_side_path
  #   find_king.pieces == 'white' ? [[0, 3], [0, 2], [0, 1]] : [[7, 3], [7, 2], [7, 1]]
  # end

  def king_side_castle(origin_piece, legal_moves)
    rook = find_king_side_rook
    return unless rook.first_move.empty?

    path = find_king_side_path
    return if blocked_path?(path)

    check_path = path.push(origin_piece.coord)
    return if path_in_check?(check_path)

    if origin_piece.pieces == 'white'
      legal_moves.push([0, 6])
      @castle_destination.push([0, 6])
    else
      legal_moves.push([7, 6])
      @castle_destination.push([7, 6])
    end
  end

  def path_in_check?(path)
    path.any? do |coord|
      king_in_check?(coord)
    end
  end 

  def find_king_side_rook
    find_king.pieces == 'white' ? @board.white_king_side_rook : @board.black_king_side_rook
  end

  def find_king_side_path
    find_king.pieces == 'white' ? [[0, 5], [0, 6]] : [[7, 5], [7, 6]]
  end

  def rook_castle(destination_coord)
    return unless @castle_destination.include?(destination_coord)

    if destination_coord == [0, 6]
      rook_start_coord = [0, 7]
      rook_destination_coord = [0, 5]
    elsif destination_coord == [7, 6]
      rook_start_coord = [7, 7]
      rook_destination_coord = [7, 5]
    elsif destination_coord == [0, 2]
      rook_start_coord = [0, 0]
      rook_destination_coord = [0, 3]
    elsif destination_coord == [7, 2]
      rook_start_coord = [7, 0]
      rook_destination_coord = [7, 3]
    end
    update_board(rook_start_coord, rook_destination_coord)
  end
end