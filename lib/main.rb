# frozen_string_literal: true

require_relative 'board.rb'
require_relative 'tree.rb'
require_relative 'game.rb'
require_relative 'player.rb'
require_relative 'knight.rb'

# game = Tree.new
# game.knight_moves([0, 0], [3, 3])
# test = Knight.new([1, 0])
# p test.possible_moves
knight_test = Game.new
knight_test.start

# Could check against list of available moves (open board spaces)
# Or could block any moves of your own pieces (except for castle rules)
# But keep moves of an opponent piece that COULD be captured, so block moves to an opponent piece that cannot be captured (illegal or puts oneself in check)


# New Game is started
    # New Game object is created in main.rb
# Board is created*
    # New Board object is initialized om Game class
        # * How is board grid set up?
        # * How are coordinates set up and used behind the scenes?
        # * How are coordinates presented to the user and taken in?
        # * If different, how are coordinates from user converted into board coordinates?
            # Use integer notation to make the program work
            # After it's working, you can introduce an algebraic notation for the display to user and just convert things to behind the scenes

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
# Current Player is prompted for a move or notified of check
# Loop ends when checkmate/draw occurs


