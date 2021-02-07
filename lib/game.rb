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
      legal_moves = find_moves(start_coord)
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

  def find_moves(coord)
    node = coords_to_node(coord)
    check_legal(node.possible_moves)
  end

  def check_legal(moves)
    legal_moves = []
    # If one of the moves includes a square with a player's own pieces, then remove from array
    moves.map do |move|
      legal_moves.push(move) if coords_to_node(move).pieces != @current_player.pieces
    end
    legal_moves
    # Later, check for putting yourself into Check
    # Also check for pieces blocking path
  end

  def ask_user_destination(legal_moves)
    loop do
      puts "Choose a destination: #{legal_moves}"
      destination = @current_player.prompt_piece
      destination_coord = string_to_array(destination)
      return destination_coord if check_destination(destination_coord, legal_moves)
    end
  end

  def check_destination(destination_coord, legal_moves)
    true if legal_moves.include?(destination_coord)
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

    # Legal Moves missing:
        # Putting self into check
        # How does it check if another piece is blocking it's path? Own pieces as well as opponent pieces

    # Main Game logic missing:
        # Computer checks for check/checkmate/draw and if true displays result
        # Current Player is notified if in check
        # Loop ends when checkmate/draw occurs