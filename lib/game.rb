# frozen_string_literal: true

# lib/chess_spec.rb

class Game
  def initialize(board = Board.new, player_one = Player.new('Player 1', 'white'), player_two = Player.new('Player 2', 'black'))
    @board = board
    @player_one = player_one
    @player_two = player_two
    @current_player = @player_one
    @current_piece = nil
  end

  def start
    # Add display for rules and how to input board positions
    # Add option to Load game file
    start_turn
  end

  def start_turn
    loop do
      display_user
      @current_piece = ask_user_start
      moves = find_piece_moves(@current_piece)
      legal_moves = find_piece_legal_moves(moves)
      redo if legal_moves.empty?

      destination_coord = ask_user_destination(legal_moves)
      start_coord = @current_piece.coord
      update_board(start_coord, destination_coord)
      swap_player
      break if game_over?
    end
  end

  # def test_blocked(legal_moves)
  #   test_moves = []

  #   legal_moves.map do |move|
  #     test_moves.push(move) if blocked?(move)
  #   end

  #   test_moves
  # end

  def blocked?(destination_move)
    origin = @current_piece
    destination = destination_move
    array = @board.path_finder(origin, destination)
    origin.children = []
    puts "For origin ( #{origin} ) the possible moves are #{origin.possible_moves} and the single_moves are #{origin.single_moves}"
    #  puts "For origin/currentpiece ( #{origin} ) with coords of ( #{origin.coord} ) and children of ( #{origin.children} ) and destination ( #{destination} ) the path array is #{array}"
    new_array = array - [destination_move]  
    final_array = new_array - [origin.coord]
    final_array.any? do |x, y|
      @board.occupied?(x, y)
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

  def find_piece_legal_moves(moves)
    legal_moves = []

    moves.map do |move|
      legal_moves.push(move) unless illegal_move?(move)
    end
    legal_moves
  end

  def illegal_move?(move)
    if occupied_by_player?(move)
      true
    elsif blocked?(move)
      true
    elsif piece_is_king?
      king_coord = move
      king_in_check?(move, king_coord)
    else
      king = find_king
      king_coord = king.coord
      king_in_check?(move, king_coord)
    end
  end

  def occupied_by_player?(move_coord)
    landing_space = coords_to_grid_object(move_coord)
    landing_space.pieces == @current_player.pieces
  end

  def piece_is_king?
    @current_piece == find_king
  end

  def find_king
    if @current_player.pieces == 'white'
      @board.white_king
    elsif @current_player.pieces == 'black'
      @board.black_king
    end
  end

  def king_in_check?(move, king_coord)
    opponent_moves = find_opponent_moves(move)
    # p opponent_moves
    coord_in_check?(king_coord, opponent_moves)
  end

  def find_opponent_moves(move)
    opponent = find_opponent
    opponent_pieces = find_pieces(opponent)
    remaining_pieces = remove_possible_capture(opponent_pieces, move)
    all_possible_moves = find_all_pieces_possible_moves(remaining_pieces).flatten(1)
    all_legal_moves = find_all_pieces_legal_moves(all_possible_moves)
    # p all_legal_moves
    # p all_possible_moves
    # find_piece_legal_moves(all_possible_moves)
    # Stack level too deep

    # Can we check legal moves prior to collecting all the possible moves. basically run through ti the same way we do for current player picks?


    # all_legal_moves = find_all_pieces_legal_moves(all_possible_moves)
    
    # all_legal_moves = find_piece_legal_moves(all_possible_moves)
  end

  def find_all_pieces_legal_moves(moves)
    array = []
    moves.map do |move|
      # p move
      array.push(move) unless blocked?(move)

      # p move
      # test = find_piece_legal_moves(move)
      # p test
    end
    p array
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

  def game_over?
    return unless checkmate?

    display_checkmate
    true
    # elsif draw?
    #   display_draw
    #   true
    # else
    #   false
    # end
  end

  def display_checkmate
    @board.show_grid
    puts "Checkmate."
  end

  def checkmate?
    player = @current_player.pieces
    player_pieces = find_pieces(player)
    player_legal_moves = all_legal_moves(player_pieces)

    king = find_king
    king_coord = king.coord
    no_player_moves?(player_legal_moves) && king_in_check?(nil, king_coord)
  end

  def all_legal_moves(player_pieces)
    player_legal_moves = []

    player_pieces.map do |piece|
      @current_piece = piece
      moves = find_piece_moves(@current_piece)
      legal_moves = find_piece_legal_moves(moves)
      player_legal_moves.push(legal_moves)
    end
    player_legal_moves
  end

  def no_player_moves?(player_legal_moves)
    all_moves = player_legal_moves.flatten(1)
    all_moves.any? == false
  end

  # def draw?
  #   # Placeholder for now
  #   false
  # end

  def swap_player
    @current_player = if @current_player == @player_one
                        @player_two
                      else
                        @player_one
                      end
  end
end

# Next Pseudo Steps

  # Main Game logic missing:

    # Computer checks for draw and if true displays result