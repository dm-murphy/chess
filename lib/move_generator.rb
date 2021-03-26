# frozen_string_literal: true

# lib/chess_spec.rb

# Responsible for generating and verifying moves for Game class
class MoveGenerator < Game

  def initialize(board, current_player)
    @board = board
    @current_player = current_player
  end

  def generate_legal_moves(piece)
    moves = find_piece_moves(piece)
    find_piece_legal_moves(moves, piece)
  end

  def find_castle_moves(origin_piece, legal_moves)
    @castle_moves = Castling.new(@board, @current_player)
    @castle_moves.castle(origin_piece, legal_moves)
  end

  def find_piece_moves(piece)
    piece.possible_moves
  end

  def find_piece_legal_moves(moves, origin_piece)
    legal_moves = []

    moves.map do |move|
      legal_moves.push(move) unless illegal_move?(move, origin_piece)
    end
    legal_moves
  end

  def illegal_move?(move, origin_piece)
    occupied_by_player?(move, origin_piece) || blocked?(move, origin_piece) ||
      move_puts_self_in_check?(move, origin_piece) || king_stays_in_check?(move, origin_piece)
  end

  def occupied_by_player?(move_coord, origin_piece)
    landing_space = coords_to_grid_object(move_coord)
    landing_space.pieces == origin_piece.pieces
  end

  def blocked?(destination_move, origin_piece)
    full_array = @board.build_path(origin_piece, destination_move)
    path_array = full_array - [destination_move] - [origin_piece.coord]
    blocked_path?(path_array)
  end

  def blocked_path?(path)
    path.any? do |x, y|
      @board.occupied?(x, y)
    end
  end

  def move_puts_self_in_check?(move, origin_piece)
    king_coord = find_king_coord(move, origin_piece)
    @board.clean_square(origin_piece.coord)
    result = king_in_check?(king_coord, move) && move_keeps_king_in_check?(move, origin_piece, king_coord)
    @board.move_piece_to_coords(origin_piece, origin_piece.coord)
    result
  end

  def king_stays_in_check?(move, origin_piece)
    king_coord = find_king_coord(move, origin_piece)
    move_keeps_king_in_check?(move, origin_piece, king_coord)
  end

  def move_keeps_king_in_check?(move, origin_piece, king_coord)
    destination_piece = coords_to_grid_object(move)
    @board.move_piece_to_coords(origin_piece, move)
    @board.clean_square(origin_piece.coord)
    result = king_in_check?(king_coord, move)
    @board.move_piece_to_coords(origin_piece, origin_piece.coord)
    @board.move_piece_to_coords(destination_piece, move)
    result
  end

  def find_king_coord(move, origin_piece)
    if piece_is_king?(origin_piece)
      move
    else
      king = find_king
      king.coord
    end
  end

  def piece_is_king?(piece)
    piece == find_king
  end

  def find_king
    if @current_player.pieces == 'white'
      @board.white_king
    elsif @current_player.pieces == 'black'
      @board.black_king
    end
  end

  def king_in_check?(king_coord, move = nil)
    opponent_moves = find_opponent_moves(move)
    coord_in_check?(king_coord, opponent_moves)
  end

  def find_opponent_moves(move)
    opponent = find_opponent
    opponent_pieces = find_pieces(opponent)
    remaining_pieces = remove_possible_capture(opponent_pieces, move)
    find_available_opponent_moves(remaining_pieces)
  end

  def find_available_opponent_moves(pieces)
    available_opponent_moves = []
    pieces.each do |piece|
      moves = find_piece_moves(piece)
      moves.each do |move|
        available_opponent_moves.push(move) unless blocked?(move, piece) || occupied_by_player?(move, piece)
      end
    end
    available_opponent_moves
  end

  def find_opponent
    if @current_player.pieces == 'white'
      'black'
    elsif @current_player.pieces == 'black'
      'white'
    end
  end

  def find_pieces(player)
    pieces = []

    @board.grid.map do |row|
      row.map do |piece|
        pieces.push(piece) if piece.pieces == player
      end
    end
    pieces
  end

  def remove_possible_capture(opponent_pieces, move)
    remaining_pieces = []

    opponent_pieces.map do |piece|
      remaining_pieces.push(piece) unless piece.coord == move
    end
    remaining_pieces
  end

  def coord_in_check?(coord, opponent_moves)
    opponent_moves.map do |move|
      return true if move == coord
    end
    false
  end

  def check?
    king = find_king
    king_coord = king.coord
    king_in_check?(king_coord)
  end

  def no_player_moves?
    player = @current_player.pieces
    player_pieces = find_pieces(player)
    player_legal_moves = all_legal_moves(player_pieces) 
    no_legal_moves?(player_legal_moves)
  end

  def all_legal_moves(player_pieces)
    player_legal_moves = []

    player_pieces.map do |piece|
      moves = find_piece_moves(piece)
      legal_moves = find_piece_legal_moves(moves, piece)
      player_legal_moves.push(legal_moves)
      # To help speed up time:
      break if player_legal_moves.flatten(1).any?
    end
    player_legal_moves
  end

  def no_legal_moves?(player_legal_moves)
    all_moves = player_legal_moves.flatten(1)
    all_moves.any? == false
  end

end
