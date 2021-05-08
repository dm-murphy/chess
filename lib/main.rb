# frozen_string_literal: true

require_relative 'game.rb'
require_relative 'move_generator.rb'
require_relative 'chess_notation.rb'
require_relative 'player.rb'
require_relative 'board.rb'
require_relative 'square.rb'
require_relative 'piece.rb'
require_relative 'pawn.rb'
require_relative 'knight.rb'
require_relative 'king.rb'
require_relative 'rook.rb'
require_relative 'bishop.rb'
require_relative 'queen.rb'
require_relative 'en_passant_moves.rb'
require_relative 'castling.rb'
require_relative 'pawn_promotion_moves.rb'

test_game = Game.new
test_game.start
