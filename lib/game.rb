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
    ask_user
  end

  def display_user
    p @board.display
    puts "#{@current_player.name} choose a piece"
    puts
  end

  def ask_user
    loop do
      current_piece = @current_player.prompt_piece
      if check_piece(current_piece)
        current_piece
        break
      end
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
end

# Next Pseudo Steps
    # Take current_piece and find possible moves
    # Show possible moves
    # Prompt for destination or (to cancel piece selection ... extra )
    # Check valid destination entry
    # Return a valid destination entry to (Game class?) or to Board class and update nodes ( change blank space to piece )
    # Display updated board
    # Switch player