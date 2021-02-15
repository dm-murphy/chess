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
      # break if game_over?
      display_user
      @current_piece = ask_user_start
      moves = find_piece_moves(@current_piece)
      legal_moves = find_legal_moves(moves)
      start_turn if legal_moves.empty?
      
      destination_coord = ask_user_destination(legal_moves)
      start_coord = @current_piece.coord
      update_board(start_coord, destination_coord)
      # break if game_over?
      swap_player
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

  def find_legal_moves(moves)
    legal_moves = []

    moves.map do |move|
      legal_moves.push(move) unless illegal_move?(move)
    end
    legal_moves
  end

  def illegal_move?(move)
    if occupied_by_player?(move)
      true
    elsif piece_is_king?
      king_coord = move
      king_in_check?(move, king_coord)
    else
      king_coord = find_king_coord
      king_in_check?(move, king_coord)
    end
  end

  def occupied_by_player?(move_coord)
    landing_space = coords_to_grid_object(move_coord)
    landing_space.pieces == @current_player.pieces
  end

  def piece_is_king?
    piece = @current_piece
    white_king?(piece) || black_king?(piece)
  end

  def white_king?(piece)
    piece == @board.white_king
  end

  def black_king?(piece)
    piece == @board.black_king
  end

  def find_king_coord
    if @current_player.pieces == 'white'
      @board.white_king.coord
    elsif @current_player.pieces == 'black'
      @board.black_king.coord
    end
  end
  
  def king_in_check?(move, king_coord)
    opponent_moves = find_opponent_moves(move)
    coord_in_check?(king_coord, opponent_moves)
  end

  def find_opponent_moves(move)
    opponent = find_opponent
    opponent_pieces = find_pieces(opponent)
    remaining_pieces = remove_possible_capture(opponent_pieces, move)
    find_possible_moves(remaining_pieces).flatten(1)
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

  def find_possible_moves(pieces)
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
    checkmate? #|| draw?
  end

  def checkmate?
    no_player_moves?
  end

  def no_player_moves?
    player = @current_player.pieces
    player_pieces = find_pieces(player)
    player_moves = find_possible_moves(player_pieces)
    p player_moves
  

  # player_pieces.map do |piece|
  # 

  # get all the player pieces
  # get all the player moves for each piece
  # run through legal moves for each piece
  # if empty then true

    legal_moves = find_legal_moves(player_moves, piece)
    # legal_moves = get the legal moves
    # if legal_moves is empty?
    # true
    false
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
    
    # Prevent moves where another piece along the way is blocking path

    # Computer checks for checkmate/draw and if true displays result

    # Tell User they are in check