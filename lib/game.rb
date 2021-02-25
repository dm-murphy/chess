# frozen_string_literal: true

# lib/chess_spec.rb

class Game
  def initialize(board = Board.new, player_one = Player.new('Player 1', 'white'), player_two = Player.new('Player 2', 'black'))
    @board = board
    @player_one = player_one
    @player_two = player_two
    @current_player = @player_one
  end

  def start
    # Add display for rules and how to input board positions
    # Add option to Load game file
    start_turn
  end

  def start_turn
    loop do
      display_user
      origin_piece = ask_user_start
      moves = find_piece_moves(origin_piece)
      legal_moves = find_piece_legal_moves(moves, origin_piece)
      redo if legal_moves.empty?

      castle_destination = []
      castle(origin_piece, legal_moves, castle_destination)

      destination_coord = ask_user_destination(legal_moves)
      start_coord = origin_piece.coord
      update_board(start_coord, destination_coord)
      rook_castle(origin_piece, destination_coord, castle_destination)
      piece_move_history(origin_piece, destination_coord)

      swap_player
      break if game_over?
    end
  end

  def piece_move_history(origin_piece, destination_coord)
    origin_piece.first_move.push(destination_coord)
  end

  def castle(origin_piece, legal_moves, castle_destination)
    return unless piece_is_king?(origin_piece)
    return unless origin_piece.first_move.empty?

    king_side_castle(origin_piece, legal_moves, castle_destination)
    queen_side_castle(origin_piece, legal_moves, castle_destination)
  end

  def queen_side_castle(origin_piece, legal_moves, castle_destination)
    rook = find_queen_side_rook
    return unless rook.first_move.empty?

    path = find_queen_side_path
    return if blocked_path?(path)

    path.pop
    check_path = path.push(origin_piece.coord)
    return if path_in_check?(check_path)

    if origin_piece.pieces == 'white'
      legal_moves.push([0, 2])
      castle_destination.push([0, 2])
    else
      legal_moves.push([7, 2])
      castle_destination.push([7, 2])
    end
  end

  def find_queen_side_rook
    find_king.pieces == 'white' ? @board.white_queen_side_rook : @board.black_queen_side_rook
  end

  def find_queen_side_path
    find_king.pieces == 'white' ? [[0, 3], [0, 2], [0, 1]] : [[7, 3], [7, 2], [7, 1]]
  end

  def king_side_castle(origin_piece, legal_moves, castle_destination)
    rook = find_king_side_rook
    return unless rook.first_move.empty?

    path = find_king_side_path
    return if blocked_path?(path)

    check_path = path.push(origin_piece.coord)
    return if path_in_check?(check_path)

    if origin_piece.pieces == 'white'
      legal_moves.push([0, 6])
      castle_destination.push([0, 6])
    else
      legal_moves.push([7, 6])
      castle_destination.push([7, 6])
    end
  end

  def path_in_check?(path)
    path.any? do |coord|
      king_in_check?(coord)
    end
  end

  def blocked_path?(path)
    path.any? do |x, y|
      @board.occupied?(x, y)
    end
  end

  def find_king_side_rook
    find_king.pieces == 'white' ? @board.white_king_side_rook : @board.black_king_side_rook
  end

  def find_king_side_path
    find_king.pieces == 'white' ? [[0, 5], [0, 6]] : [[7, 5], [7, 6]]
  end

  def display_user
    @board.show_grid
    puts "#{@current_player.name} choose a piece"
    puts
  end

  def ask_user_start
    loop do
      string = @current_player.select_piece
      coord = string_to_coord(string)
      piece = coords_to_grid_object(coord)
      return piece if player_piece?(piece)
    end
  end

  def string_to_coord(string)
    string.chomp.split('').map(&:to_i)
  end

  def player_piece?(piece)
    piece.pieces == @current_player.pieces
  end

  def coords_to_grid_object(coord)
    row = coord.first
    column = coord.last
    @board.grid[row][column]
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
    origin = origin_piece
    destination = destination_move
    array = @board.path_finder(origin, destination)
    origin.children = []
    new_array = array - [destination_move]  
    final_array = new_array - [origin.coord]
    final_array.any? do |x, y|
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

  def find_all_pieces_possible_moves(pieces)
    pieces.map(&:possible_moves)
  end

  def coord_in_check?(coord, opponent_moves)
    opponent_moves.map do |move|
      return true if move == coord
    end
    false
  end

  def ask_user_destination(legal_moves)
    loop do
      puts "Choose a destination: #{legal_moves}"
      destination = @current_player.select_piece
      destination_coord = string_to_coord(destination)
      return destination_coord if legal_moves.include?(destination_coord)
    end
  end

  def update_board(start_coord, destination_coord)
    @board.change_pieces(start_coord, destination_coord)
  end

  def rook_castle(origin_piece, destination_coord, castle_destination)
    return unless castle_destination.include?(destination_coord)

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

  # def king_castled?
  # end

  def game_over?
    if checkmate?
      display_checkmate
      true
    elsif draw?
      display_draw
      true
    end
  end

  def display_draw
    @board.show_grid
    puts 'Draw.'
  end

  def draw?
    no_player_moves?
  end

  def display_checkmate
    @board.show_grid
    puts 'Checkmate.'
  end

  def checkmate?
    king = find_king
    king_coord = king.coord
    return unless king_in_check?(king_coord)

    no_player_moves?
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
    end
    player_legal_moves
  end

  def no_legal_moves?(player_legal_moves)
    all_moves = player_legal_moves.flatten(1)
    all_moves.any? == false
  end

  def swap_player
    @current_player = if @current_player == @player_one
                        @player_two
                      else
                        @player_one
                      end
  end
end

# Next Pseudo Steps

  

  # Write tests for new methods (#find_available_opponent_moves, #move_shields_king, #move_puts_self_in_check)

  # Main Game logic missing:

      # Castling

      # Bishops

      # Queens

      # Pawns