# frozen_string_literal: true

# lib/chess_spec.rb

# Responsible for cycling through game turns until game ends
class Game
  attr_accessor :board, :player_one, :player_two

  def initialize(board = Board.new, player_one = Player.new('Player 1', 'white'), player_two = Player.new('Player 2', 'black'))
    @board = board
    @player_one = player_one
    @player_two = player_two
    @move_generator = MoveGenerator.new(board, player_one, player_two)
  end

  def start
    display_tutorial
    # Add option to Load game file
    start_turn
  end

  def display_tutorial
    puts <<-HEREDOC

    Welcome to Chess. 
    
    Players take turns choosing pieces and destinations.
    
    Select a piece by entering the column with a letter from a - h
    followed by the row with a number from 1 - 8.
    
    E.g. the first player can select the kingside knight with g1
    or the leftmost pawn with a2.

    If a piece has legal moves available, the board will display them,
    otherwise the player must choose another piece.

    If a player is in check, they can only select pieces that can bring
    them out of check.

    HEREDOC
  end

  def start_turn
    loop do
      @board.show_grid
      origin_piece = @move_generator.ask_user_start
      legal_moves = @move_generator.generate_legal_moves(origin_piece)
      redo if legal_moves.empty?

      destination_coord = @move_generator.ask_user_destination(legal_moves)
      start_coord = origin_piece.coord
      @move_generator.update_pieces(origin_piece, destination_coord, start_coord)
      @move_generator.swap_player
      break if game_over?
    end
  end

  def game_over?
    return unless @move_generator.no_player_moves?

    @board.show_grid
    if @move_generator.check?
      display_checkmate
    else
      display_draw
    end
    true
  end

  def display_checkmate
    puts 'Checkmate.'
  end

  def display_draw
    puts 'Draw.'
  end
end
