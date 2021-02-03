# frozen_string_literal: true

# lib/chess_spec.rb

class Game
  def initialize(board = Board.new)#, player_one = Player.new('white'), player_two = Player.new('black'))
    @board = board
    #@player_one = player_one
    #@player_two = player_two
  end

  def start
    @board.start_pieces_knight
    p @board.display
  end
end

# Next Pseudo Steps
    # Make player class
    # Initiliaze new Player One object in Game class
    # Set Player class values for piece color, name ("Player One vs Player Two")
    # Make input prompt from Game to Player object
    # Make Player class method to receive user input on piece selection
    # Prevent non-eligible selections
    # Show possible moves
    # Prompt for destination or (to cancel piece selection ... extra )
    # Check valid destination entry
    # Return a valid destination entry to (Game class?) or to Board class and update nodes ( change blank space to piece )
    # Display updated board
    # Switch player