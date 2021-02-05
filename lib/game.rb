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
    display_user
    start_position = ask_user_start
    destinations = possible_moves(start_position)
    end_position = ask_user_end(destinations)
    p end_position
    update_board(start_position, end_position)
  end

  def update_board(start_position, end_position)    
    puts "This is start position: #{start_position}"
    puts "This is end position: #{end_position}"
    row = start_position[0].to_i
    column = start_position[1].to_i
    end_row = end_position[0].to_i
    end_column = end_position[1].to_i
    puts "This is row: #{row}"
    puts "This is column: #{column}"
    puts "this is end_row: #{end_row}"
    puts "this is end_column: #{end_column}"
    @board.change_piece(row, column, end_row, end_column)
    display_user
  end

  def display_user
    p @board.display
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
    true if current_piece == '01'

    # Piece has to belong to user's pieces (or it should be a knight object and value of white if player 1 or black if player 2) && piece has to have a possible move
    # So does a node exist here?
    # Does that node belong to current_player.pieces?
    # Does that node have 1+ possible moves?
    # If yes to all that, then prompt User for destination    
  end

  def possible_moves(position)
    row = position[0].to_i
    column = position[1].to_i
    @board.grid[row][column].possible_moves
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
    # Make Board have display of Node object's piece value or of blank hyphen space
    # Perhaps make new @display_grid that is a 2D array with coordinates just for displays. So one for displays and one for nodes
    # Switch player
    # Or work on repeating the turn and moving again
    # Change hardwired #check_piece in Game class to a real conditional