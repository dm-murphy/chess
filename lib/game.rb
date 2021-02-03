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
    start_position = ask_user
    possible_moves(start_position)
  end

  def display_user
    p @board.display
    puts "#{@current_player.name} choose a piece"
    puts
  end

  def ask_user
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
    # So really it's get the node object from that position and then get possible moves from that class's piece?
    row = position[0].to_i
    column = position[1].to_i
    p @board.grid[row][column]

    # So it's giving me the display ("N") because the Board grid is set to the display value of the node instead of the node itself
    # Solution: Keep the node itself as the grid value but find way to display the board separately with display values to user

  end
end

# Next Pseudo Steps
    # Take current_piece and find possible moves
    # Show possible moves
    # Prompt for destination or (to cancel piece selection ... extra )
    # Check valid destination entry
    # Return a valid destination entry to (Game class?) or to Board class and update nodes ( change blank space to piece )
    # Display updated board
    # Switch player