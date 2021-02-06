# frozen_string_literal: true

require_relative 'board.rb'
require_relative 'game.rb'
require_relative 'player.rb'
require_relative 'knight.rb'
require_relative 'square.rb'

knight_test = Game.new
knight_test.start

# New Game is started
    # New Game object is created in main.rb
    
    # Board is created*
        # New Board object is initialized om Game class

    # Player 1 is created - set to White
        # Initialized in Game class
        # All Player 1 pieces will be white
    # Player 2 is created - set to Black
        # Initialized in Game class
        # All Player 2 pieces will be black
    # Player 1 is set to Current Player
        # Initialized in Game class


# Loop begins for Current Player
# Board is displayed
# Current Player is prompted for move
# Current Player picks one of their pieces
# Computer makes sure it is one of their pieces, right coordinates and that it has possible moves
# Current Player picks destination
# Compiuter checks that destination is an available move out of the possible moves

        # Computer updates the board to reflect the move and any captures/checks that follow

        # Computer checks for checkmate/draw and if true displays result

# Computer switches Current Player
# Computer displays updated board
# Current Player is prompted for a move
        
        # Current Player is notified if in check
        
        # Loop ends when checkmate/draw occurs


