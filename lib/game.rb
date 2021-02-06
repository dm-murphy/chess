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
      destinations = possible_moves(start_position)
      end_position = ask_user_end(destinations)
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
    # puts "This is start position: #{start_position}"
    # puts "This is end position: #{end_position}"
    row = start_position[0].to_i
    column = start_position[1].to_i
    end_row = end_position[0].to_i
    end_column = end_position[1].to_i
    # puts "This is row: #{row}"
    # puts "This is column: #{column}"
    # puts "this is end_row: #{end_row}"
    # puts "this is end_column: #{end_column}"
    @board.change_piece(row, column, end_row, end_column)
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

  def ask_user_end(destinations)
    loop do
      puts "Choose a square: #{destinations}"
      current_destination = @current_player.prompt_piece
      return current_destination if check_destination(current_destination, destinations)
    end
  end

  def check_destination(current_destination, destinations)
    converted_destination = current_destination.chomp.split('').map(&:to_i)
    true if destinations.include?(converted_destination)
  end
end

# Next Pseudo Steps
