# frozen_string_literal: true

# lib/chess_spec.rb

# Responsible for providing castling move coordinates to MoveGenerator class
class Castling < MoveGenerator
  attr_accessor :castle_destination

  def initialize(board, current_player)
    @board = board
    @current_player = current_player
    @castle_destination = []
  end

  def castle(origin_piece, legal_moves)
    return unless piece_is_king?(origin_piece)
    return unless origin_piece.first_move.empty?

    king_side_castle(origin_piece, legal_moves)
    queen_side_castle(origin_piece, legal_moves)
  end

  def king_side_castle(origin_piece, legal_moves)
    rook = find_king_side_rook
    return unless rook.first_move.empty?

    path = find_king_side_path
    return if blocked_path?(path)

    check_path = path.push(origin_piece.coord)
    return if path_in_check?(check_path)

    add_king_side_move(origin_piece, legal_moves)
  end

  def add_king_side_move(origin_piece, legal_moves)
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

  def queen_side_castle(origin_piece, legal_moves)
    rook = find_queen_side_rook
    return unless rook.first_move.empty?

    path = find_queen_side_path
    return if blocked_path?(path)

    path.pop
    check_path = path.push(origin_piece.coord)
    return if path_in_check?(check_path)

    add_queen_side_move(origin_piece, legal_moves)
  end

  def add_queen_side_move(origin_piece, legal_moves)
    if origin_piece.pieces == 'white'
      legal_moves.push([0, 2])
      @castle_destination.push([0, 2])
    else
      legal_moves.push([7, 2])
      @castle_destination.push([7, 2])
    end
  end

  def find_queen_side_rook
    find_king.pieces == 'white' ? @board.white_queen_side_rook : @board.black_queen_side_rook
  end

  def find_queen_side_path
    find_king.pieces == 'white' ? [[0, 3], [0, 2], [0, 1]] : [[7, 3], [7, 2], [7, 1]]
  end

  def rook_castled?(destination_coord)
    @castle_destination.include?(destination_coord)
  end

  def find_rook_start(destination_coord)
    if destination_coord == [0, 6]
      [0, 7]
    elsif destination_coord == [7, 6]
      [7, 7]
    elsif destination_coord == [0, 2]
      [0, 0]
    elsif destination_coord == [7, 2]
      [7, 0]
    end
  end

  def find_rook_destination(destination_coord)
    if destination_coord == [0, 6]
      [0, 5]
    elsif destination_coord == [7, 6]
      [7, 5]
    elsif destination_coord == [0, 2]
      [0, 3]
    elsif destination_coord == [7, 2]
      [7, 3]
    end
  end
end
