# frozen_string_literal: true

# lib/chess_spec.rb

# Responsible for cycling through turns between players in game until game ends
class Game
  attr_accessor :board, :player_one, :player_two

  def initialize(board = Board.new, player_one = Player.new('Player 1', 'white'), player_two = Player.new('Player 2', 'black'))
    @board = board
    @player_one = player_one
    @player_two = player_two
    @move_generator = MoveGenerator.new(board, player_one, player_two)
  end

  def start
    # Add display for rules and how to input board positions
    # Add option to Load game file
    start_turn
  end

  def start_turn
    loop do
      display_user
      origin_piece = ask_user_start
      legal_moves = generate_legal_moves(origin_piece)
      redo if legal_moves.empty?

      destination_coord = ask_user_destination(legal_moves)
      start_coord = origin_piece.coord
      test_new_update_pieces(origin_piece, destination_coord, start_coord)
      break if game_over?
    end
  end

  def test_new_update_pieces(origin_piece, destination_coord, start_coord)
    @move_generator.update_pieces(origin_piece, destination_coord, start_coord)
  end

  def generate_legal_moves(origin_piece)
    @move_generator.generate_legal_moves(origin_piece)
  end

  def display_user
    @board.show_grid
  end

  def ask_user_start
    loop do
      string = @move_generator.ask_move
      coord = string_to_coord(string)
      piece = coords_to_grid_object(coord)
      return piece if player_piece?(piece)
    end
  end

  def string_to_coord(string)
    string.chomp.split('').map(&:to_i)
  end

  def player_piece?(piece)
    piece.pieces == @move_generator.current_player.pieces
  end

  def coords_to_grid_object(coord)
    row = coord.first
    column = coord.last
    @board.grid[row][column]
  end

  def ask_user_destination(legal_moves)
    loop do
      puts "Choose a destination: #{legal_moves}"
      destination = @move_generator.current_player.select_piece
      destination_coord = string_to_coord(destination)
      return destination_coord if legal_moves.include?(destination_coord)
    end
  end

  def display_draw
    @board.show_grid
    puts 'Draw.'
  end

  def display_checkmate
    @board.show_grid
    puts 'Checkmate.'
  end

  def game_over?
    return unless @move_generator.no_player_moves?

    if @move_generator.check?
      display_checkmate
    else
      display_draw
    end
    true
  end
end
