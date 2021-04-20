# frozen_string_literal: true

# lib/chess_spec.rb

# Responsible for generating and verifying moves for Game class
class MoveGenerator
  attr_accessor :current_player

  def initialize(board, player_one, player_two)
    @board = board
    @player_one = player_one
    @player_two = player_two
    @current_player = player_one
    @en_passant_moves = EnPassantMoves.new(board)
  end

  # New method
  def remove_piece(coord)
    @board.clean_square(coord)
  end
  
  # New method
  def ask_move
    puts "#{@current_player.name} choose a piece"
    puts
    @current_player.select_piece
  end

  def swap_player
    @current_player = if @current_player == @player_one
                        @player_two
                      else
                        @player_one
                      end
  end

  def coords_to_grid_object(coord)
    row = coord.first
    column = coord.last
    @board.grid[row][column]
  end

  def player_piece?(piece)
    piece.pieces == @current_player.pieces
  end

  def update_pieces(origin_piece, destination_coord, start_coord)
    puts "MOve Generator object thinks #{@current_player} is #{@current_player.pieces}"
    # swap_player
    # puts "Current player is #{@@current_player.pieces}"
    # swap_player
    @en_passant_moves.test_new_en_passant_script(origin_piece, destination_coord, start_coord)
    # update_captured_en_passant(destination_coord)
    # check_en_passant(origin_piece, destination_coord, start_coord)
    update_piece_move_history(origin_piece, destination_coord)
    check_pawn_promotion(origin_piece, destination_coord, start_coord)
    update_board(start_coord, destination_coord)
    
    update_castling_rooks(destination_coord)
    swap_player
  end

  def update_board(start_coord, destination_coord)
    @board.change_pieces(start_coord, destination_coord)
  end

  def update_castling_rooks(destination_coord)
    return unless castled?(destination_coord)

    rook_start_coord = rook_start(destination_coord)
    rook_destination_coord = rook_destination(destination_coord)
    update_board(rook_start_coord, rook_destination_coord)
  end

  def update_piece_move_history(origin_piece, destination_coord)
    return unless defined?(origin_piece.first_move)

    origin_piece.first_move.push(destination_coord)
  end

  def check_pawn_promotion(origin_piece, destination_coord, start_coord)
    return unless origin_piece.class == Pawn
    return unless destination_coord.first == 7 || destination_coord.first == 0

    piece_selection_number = prompt_pawn_promotion
    promoted_piece_name = find_piece_class(piece_selection_number)
    pieces = origin_piece.pieces
    @board.promote_pawn(promoted_piece_name, start_coord, pieces)
  end

  def prompt_pawn_promotion
    puts "#{@current_player.name} select piece for pawn promotion:"
    puts "1 = Queen"
    puts "2 = Knight"
    puts "3 = Rook"
    puts "4 = Bishop"
    loop do
      string = @current_player.select_piece.to_i
      return string if string.between?(1, 4)
    end
  end

  def find_piece_class(piece_selection_number)
    hash = { "Queen" => 1, "Knight" => 2, "Rook" => 3, "Bishop" => 4 }
    hash.key(piece_selection_number)
  end


  def generate_legal_moves(piece)
    legal_moves = find_legal_moves(piece)
    find_en_passant_capture_move(piece, legal_moves)
    find_castle_moves(piece, legal_moves)
    legal_moves
  end

  def find_en_passant_capture_move(piece, legal_moves)
    @en_passant_moves.apply_en_passant(piece, legal_moves)
  end

  def find_legal_moves(piece)
    moves = find_piece_moves(piece)
    find_piece_legal_moves(moves, piece)
  end

  def find_castle_moves(origin_piece, legal_moves)
    @castle_moves = Castling.new(@board, @player_one, @player_two)
    @castle_moves.castle(origin_piece, legal_moves)
  end

  def castled?(destination_coord)
    @castle_moves.rook_castled?(destination_coord)
  end

  def rook_start(destination_coord)
    @castle_moves.find_rook_start(destination_coord)
  end

  def rook_destination(destination_coord)
    @castle_moves.find_rook_destination(destination_coord)
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
      move_puts_self_in_check?(move, origin_piece) || king_stays_in_check?(move, origin_piece) ||
      illegal_pawn_move?(move, origin_piece)
  end

  def illegal_pawn_move?(move, origin_piece)
    return unless origin_piece.class == Pawn

    origin_coords = origin_piece.coord
    coord_change = subtract_coordinates(move, origin_coords)

    if origin_piece.forward_moves.include?(coord_change)
      pawn_move_blocked?(move, origin_piece)
    elsif origin_piece.diagonal_attacks.include?(coord_change)
      pawn_attack_invalid?(move, origin_piece)
    end
  end

  # # Move back to Move Generator
  def subtract_coordinates(move, origin_coords)
    result_x = move[0] - origin_coords[0]
    result_y = move[1] - origin_coords[1]
    [result_x, result_y]
  end

  def pawn_move_blocked?(move, origin_piece)
    array = @board.build_path(origin_piece, move)
    pawn_path = array - [origin_piece.coord]
    blocked_path?(pawn_path)
  end

  def pawn_attack_invalid?(move, origin_piece)
    destination_square = coords_to_grid_object(move)
    player_piece?(destination_square) || @board.empty_space?(move)
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
    puts "OK so origin piece is #{origin_piece} and move is #{move}"
    king_coord = find_king_coord(move, origin_piece)
    @board.clean_square(origin_piece.coord)
    # puts "OK so king coord is #{king_coord} and move is #{move}"
    result = king_in_check?(origin_piece, king_coord, move) && move_keeps_king_in_check?(move, origin_piece, king_coord)
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
    result = king_in_check?(origin_piece, king_coord, move)
    @board.move_piece_to_coords(origin_piece, origin_piece.coord)
    @board.move_piece_to_coords(destination_piece, move)
    result
  end

  def find_king_coord(move, origin_piece)
    if piece_is_king?(origin_piece)
      move
    else
      king = find_king(origin_piece)
      king.coord
    end
  end

  def piece_is_king?(piece)
    piece == find_king(piece)
  end

  def find_king(piece)
    if piece.pieces == 'white'
      @board.white_king
    elsif piece.pieces == 'black'
      @board.black_king
    end
  end

  def king_in_check?(piece, king_coord, move = nil)
    opponent = find_opponent(piece) #New
    opponent_moves = find_opponent_moves(opponent, move)
    coord_in_check?(king_coord, opponent_moves)
  end

  def find_opponent_moves(opponent, move)
    # New removed find opponent added opponent argument to find_opponent_moves
    
    
    opponent_pieces = find_pieces(opponent)
  
    # opponent_pieces.map do |piece|
    #   p piece
    # end



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

  # Move back to Move Generator
  def find_opponent(piece)
    #Refactored to add coord argument and find piece instead of current player
    if piece.pieces == 'white'
      'black'
    elsif piece.pieces == 'black'
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
    king = find_player_king
    king_coord = king.coord
    king_in_check?(king, king_coord)
  end

  # New Method
  def find_player_king
    if @current_player.pieces == 'white'
      @board.white_king
    elsif @current_player.pieces == 'black'
      @board.black_king
    end
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
