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
      start_coord = ask_user_start
      node = coords_to_node(start_coord)
      moves = find_node_moves(node)
      legal_moves = find_legal_moves(moves, node)
      start_turn if legal_moves.empty?

      destination_coord = ask_user_destination(legal_moves)
      update_board(start_coord, destination_coord)
      break if game_over?

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
      current_piece = @current_player.prompt_piece
      current_coord = string_to_array(current_piece)
      return current_coord if check_piece(current_coord)
    end
  end

  def string_to_array(position)
    position.chomp.split('').map(&:to_i)
  end

  def check_piece(current_coord)
    node = coords_to_node(current_coord)
    true if node.pieces == @current_player.pieces && node.possible_moves.empty? == false
  end

  def coords_to_node(coord)
    row = coord.first
    column = coord.last
    @board.grid[row][column]
  end

  def find_node_moves(node)
    node.possible_moves
  end

  def find_legal_moves(moves, node)
    legal_moves = []

    moves.map do |move|
      legal_moves.push(move) unless illegal_move?(move, node)
    end
    legal_moves
  end

  def illegal_move?(move, node)
    occupied_by_player?(move, node) || king_in_check?(move, node)
  end

  def occupied_by_player?(move_coord, moving_piece)
    landing_node = coords_to_node(move_coord)
    landing_node.pieces == moving_piece.pieces
  end

  def king_in_check?(move, node)
    king_coord = king_is_moving?(node) ? move : find_king_coord
    opponent_moves = find_opponent_moves(move)
    coord_in_check?(king_coord, opponent_moves)
  end

  def king_is_moving?(node)
    white_king?(node) || black_king?(node)
  end

  def white_king?(node)
    node == @board.white_king
  end

  def black_king?(node)
    node == @board.black_king
  end

  def find_king_coord
    if @current_player.pieces == 'white'
      @board.white_king.coord
    elsif @current_player.pieces == 'black'
      @board.black_king.coord
    end
  end

  def find_opponent_moves(move)
    opponent = find_opponent
    opponent_pieces = find_opponent_pieces(opponent)
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

  def find_opponent_pieces(opponent)
    opponent_pieces = []

    @board.grid.map do |row|
      row.map do |piece|
        opponent_pieces.push(piece) if piece.pieces == opponent
      end
    end
    opponent_pieces
  end

  def remove_possible_capture(opponent_pieces, move)
    remaining_pieces = []

    opponent_pieces.map do |piece|
      remaining_pieces.push(piece) unless piece.coord == move
    end
    remaining_pieces
  end

  def find_possible_moves(opponent_pieces)
    opponent_pieces.map(&:possible_moves)
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
      destination = @current_player.prompt_piece
      destination_coord = string_to_array(destination)
      return destination_coord if legal_moves.include?(destination_coord)
    end
  end



  def update_board(start_coord, destination_coord)
    @board.change_pieces(start_coord, destination_coord)
  end

  def game_over?
    # Hard code false for now
    # Conditional check for Draw or Checkmate
    false
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

  # Write tests:
        
    # White King cannot put self into check
    # Black King cannot put self into check
    # White is notified if in check
    # Black is notified if in check
    # Knight can capture opponent Knight
    # King can capture opponent Knight

  # Main Game logic missing:
     
    # Don't allow user to select a piece with no moves... ahead of time? Could Dry up a lot of the user prompt methods like in check_piece
    
    # Prevent moves where another piece along the way is blocking path

    # Computer checks for checkmate/draw and if true displays result

    # Tell User they are in check