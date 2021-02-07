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
    @board.start_pieces_knight
    start_turn
  end

  def start_turn
    loop do
      display_user
      start_position = ask_user_start
      moves = possible_moves(start_position)
      legal_moves = check_legal(moves)
      end_position = ask_user_end(legal_moves)
      update_board(start_position, end_position)
      break if game_over?

      swap_player
    end
  end

  def game_over?
    # Hard code false for now
    # Check for Draw or Checkmate
    false
  end

  def swap_player
    @current_player = if @current_player == @player_one
                        @player_two
                      else
                        @player_one
                      end
  end

  def update_board(start_position, end_position)
    row = find_row(start_position)
    column = find_column(start_position)
    end_row = find_row(end_position)
    end_column = find_column(end_position)
    @board.change_piece(row, column, end_row, end_column)
  end

  def find_row(position)
    position[0].to_i
  end

  def find_column(position)
    position[1].to_i
  end

  def display_user
    @board.show_grid
    puts "#{@current_player.name} choose a piece"
    puts
  end

  def ask_user_start
    loop do
      current_piece = @current_player.prompt_piece
      return current_piece if check_piece(current_piece)
    end
  end

  def check_piece(current_piece)
    node = coords_to_node(current_piece)
    true if node.pieces == @current_player.pieces && node.possible_moves.empty? == false 
  end

  def coords_to_node(coords)
    row = coords[0].to_i
    column = coords[1].to_i
    @board.grid[row][column]
  end

  def possible_moves(position)
    node = coords_to_node(position)
    node.possible_moves
  end

  def check_legal(moves)
    legal_moves = []
    # If one of the moves includes a square with a player's own pieces, then remove from array
    moves.map do |move|
      legal_moves.push(move) if coords_to_node(move).pieces != @current_player.pieces
    end
    legal_moves

    # Later, check for putting yourself into Check
    # Also check for one of your pieces blocking you along the way to the destination, so would need to calculate all the squares along the way and see if one's own pieces are blocking
  end

  def ask_user_end(legal_moves)
    loop do
      puts "Choose a square: #{legal_moves}"
      current_destination = @current_player.prompt_piece
      return current_destination if check_destination(current_destination, legal_moves)
    end
  end

  def check_destination(current_destination, moves)
    converted_destination = current_destination.chomp.split('').map(&:to_i)
    true if moves.include?(converted_destination)
  end
end

# Next Pseudo Steps

# Run through possible_moves array and REMOVE any illegal moves
    # Illegal moves: Uncapturable pieces? King, but wouldn't this already be triggered by a prior 'check' check?
    # Putting self into check
    # How does it check if another piece is blocking it's path? Own pieces as well as opponent pieces
    # Start small: Add a second knight node of White pieces
        # Don't let one knight move to position of other knight
        # So check if possible_moves array includes a position of Board grid with an existing node of own player pieces. If yes, then remove
        # If grid node is blank square, then don't remove for KNIGHT (not same with other pieces that might have a blocked path)
        # If grid node exists and pieces are Black, and NOT their king???, but really any knight move here is good? Don't remove
        # Basically for knight, the other grid position it can't move to is where it's own node pieces exist

# Main Game logic missing:
        # Computer checks for check/checkmate/draw and if true displays result
        # Current Player is notified if in check
        # Loop ends when checkmate/draw occurs