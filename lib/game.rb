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
    p @board.display
    @current_player.prompt_piece
  end
end

# Next Pseudo Steps
    
    
    
    # Make input prompt from Game to Player object
      # Makje current player
      # Prompt current player for piece
    # Make Player class method to receive user input on piece selection
    # Prevent non-eligible selections
    # Show possible moves
    # Prompt for destination or (to cancel piece selection ... extra )
    # Check valid destination entry
    # Return a valid destination entry to (Game class?) or to Board class and update nodes ( change blank space to piece )
    # Display updated board
    # Switch player