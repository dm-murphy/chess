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

      find_castle_moves(origin_piece, legal_moves)


      
      destination_coord = ask_user_destination(legal_moves)
      start_coord = origin_piece.coord
      update_board(start_coord, destination_coord)
      update_castling_rooks(destination_coord)
      piece_move_history(origin_piece, destination_coord)
      swap_player


      # break if game_over?



    end
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
    # PROBLEM IN BLOCKED

    origin = origin_piece
    destination = destination_move
    array = @board.path_finder(origin, destination)
    origin.children = []
    new_array = array - [destination_move]  
    final_array = new_array - [origin.coord]
    puts "#{origin_piece} making this move #{destination_move} has this final array #{final_array}"
    blocked_path?(final_array)    
    # final_array.any? do |x, y|
    #   @board.occupied?(x, y)
    # end
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
    # puts "move #{move} of origin #{origin_piece} with king coord #{king_coord} puts self in check #{result}"
    result
  end

  def king_stays_in_check?(move, origin_piece)
    king_coord = find_king_coord(move, origin_piece)
    # p king_coord
    move_keeps_king_in_check?(move, origin_piece, king_coord)
  end

  def move_keeps_king_in_check?(move, origin_piece, king_coord)
    # puts "Move: #{move}  Origin Piece: #{origin_piece}   King_coord:  #{king_coord}"


    ######## FIND THIS FOR NEXT SESSION
    # Missing the Board clean square to allow Queen to check King on route to Rook in 7, 7?
    # And do you have to move it back?
    destination_piece = coords_to_grid_object(move)
    @board.move_piece_to_coords(origin_piece, move)

    @board.clean_square(origin_piece.coord)
    # @board.show_grid
    # p @board.grid[5][5]



    result = king_in_check?(king_coord, move)
    @board.move_piece_to_coords(origin_piece, origin_piece.coord)
    @board.move_piece_to_coords(destination_piece, move)
    # puts "MOVE #{move} of ORIGIN #{origin_piece} with KING COORD #{king_coord} _KEEPS_KING_IN_CHECK #{result}"
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
    # test = coords_to_grid_object(king_coord)
    # p test


    opponent_moves = find_opponent_moves(move)
    coord_in_check?(king_coord, opponent_moves)
  end


  # This does speed things up significantly until a piece is in check
  # def king_in_check?(king_coord, move = nil)
    
    

  #   king = find_king

    
  #   king_check_squares = king.find_possible_check_squares(king_coord)
    
    
  #   possible_checks = new_find_opponent_moves(king_check_squares)

  #   opponent_pieces = make_opponent_pieces(possible_checks)

  #   remaining_pieces = remove_possible_capture(opponent_pieces, move)
    
    
    
  #   opponent_moves = find_available_opponent_moves(remaining_pieces)
    
  #   coord_in_check?(king_coord, opponent_moves)
  # end

  def make_opponent_pieces(remaining_checks)
    opponent_pieces = []
    remaining_checks.each do |coord|
      object = coords_to_grid_object(coord)
      opponent_pieces.push(object)
    end
    opponent_pieces
  end

  def new_remove_move_square(possible_checks, move)
    remaining_checks = []
    possible_checks.map do |coord|
      remaining_checks.push(coord) unless coord == move
    end
    remaining_checks
  end

  def new_find_opponent_moves(king_check_squares)
    possible_checks = []
    opponent = find_opponent
    
    king_check_squares.map do |coord|
      possible_checks.push(coord) if coords_to_grid_object(coord).pieces == opponent
    end
    possible_checks
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

  def find_castle_moves(origin_piece, legal_moves)
    @castle_moves = Castling.new(@board, @current_player)
    @castle_moves.castle(origin_piece, legal_moves)
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

  def update_castling_rooks(destination_coord)
    return unless @castle_moves.rook_castled?(destination_coord)

    rook_start_coord = @castle_moves.find_rook_start(destination_coord)
    rook_destination_coord = @castle_moves.find_rook_destination(destination_coord)
    update_board(rook_start_coord, rook_destination_coord)
  end

  def piece_move_history(origin_piece, destination_coord)
    origin_piece.first_move.push(destination_coord)
  end

  # def game_over?
  #   if checkmate?
  #     display_checkmate
  #     true
  #   elsif draw?
  #     display_draw
  #     true
  #   end
  # end

  def display_draw
    @board.show_grid
    puts 'Draw.'
  end

  def draw?
    puts "Draw's no player moves also takes forever"
    no_player_moves?
  end

  def display_checkmate
    @board.show_grid
    puts 'Checkmate.'
  end

  def game_over?
    return unless no_player_moves?

    if check?
      display_checkmate
    else
      display_draw
    end
    true
  end

  def check?
    king = find_king
    king_coord = king.coord
    king_in_check?(king_coord)
  end


  # def checkmate?
  #   king = find_king
  #   king_coord = king.coord
  #   return unless king_in_check?(king_coord)

  #   puts "Do you see me?"
    
  #   # No player moves runs twice because of game_over setup
  #   no_player_moves?
  # end
  
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


  # def all_legal_moves(player_pieces)
  #   player_legal_moves = []

  #   player_pieces.map do |piece|
  #     moves = find_piece_moves(piece)
      
  #     legal_moves = find_piece_legal_moves(moves, piece)
      
  #     player_legal_moves.push(legal_moves)
  #   end
  #   player_legal_moves
  # end

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



      # Bishops

      # Queens

      # Pawns