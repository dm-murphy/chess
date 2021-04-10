# frozen_string_literal: true

# lib/chess_spec.rb

# Responsible for cycling through turns between players in game until game ends
class Game
  def initialize(board = Board.new, player_one = Player.new('Player 1', 'white'), player_two = Player.new('Player 2', 'black'))
    @board = board
    @player_one = player_one
    @player_two = player_two
    @current_player = @player_one
    @move_generator = update_move_generator
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

      generate_castle_moves(origin_piece, legal_moves)
      destination_coord = ask_user_destination(legal_moves)
      start_coord = origin_piece.coord
      update_pieces(origin_piece, destination_coord, start_coord)
      swap_player
      break if game_over?
    end
  end

  def update_pieces(origin_piece, destination_coord, start_coord)
    update_piece_move_history(origin_piece, destination_coord)
    check_pawn_promotion(origin_piece, destination_coord, start_coord)
    # Swap origin piece with promoted piece and make start coords equal then continue as usual
    update_board(start_coord, destination_coord)
    update_castling_rooks(destination_coord)
  end

  def check_pawn_promotion(origin_piece, destination_coord, start_coord)
    return unless origin_piece.class == Pawn
    return unless destination_coord.first == 7 || destination_coord.first == 0

    piece_selection_number = prompt_pawn_promotion
    promoted_piece_name = find_piece_class(piece_selection_number)
    pieces = origin_piece.pieces
    @board.promote_pawn(promoted_piece_name, start_coord, pieces)
  end

  def prompt_pawn_promotion
    puts "#{@current_player.name} select piece for pawn promotion:"
    puts "1 = Queen"
    puts "2 = Knight"
    puts "3 = Rook"
    puts "4 = Bishop"
    loop do
      string = @current_player.select_piece.to_i
      return string if string.between?(1, 4)
    end
  end

  def find_piece_class(piece_selection_number)
    hash = { "Queen" => 1, "Knight" => 2, "Rook" => 3, "Bishop" => 4 }
    hash.key(piece_selection_number)
  end

  def update_move_generator
    @move_generator = MoveGenerator.new(@board, @current_player)
  end

  def generate_legal_moves(origin_piece)
    update_move_generator
    @move_generator.generate_legal_moves(origin_piece)
  end

  def generate_castle_moves(origin_piece, legal_moves)
    @move_generator.find_castle_moves(origin_piece, legal_moves)
  end

  def update_castling_rooks(destination_coord)
    return unless @move_generator.castled?(destination_coord)

    rook_start_coord = @move_generator.rook_start(destination_coord)
    rook_destination_coord = @move_generator.rook_destination(destination_coord)
    update_board(rook_start_coord, rook_destination_coord)
  end

  def display_user
    @board.show_grid
    puts "#{@current_player.name} choose a piece"
    puts
  end

  def ask_user_start
    loop do
      string = @current_player.select_piece
      coord = string_to_coord(string)
      piece = coords_to_grid_object(coord)
      return piece if player_piece?(piece)
    end
  end

  def string_to_coord(string)
    string.chomp.split('').map(&:to_i)
  end

  def player_piece?(piece)
    piece.pieces == @current_player.pieces
  end

  def coords_to_grid_object(coord)
    row = coord.first
    column = coord.last
    @board.grid[row][column]
  end

  def ask_user_destination(legal_moves)
    loop do
      puts "Choose a destination: #{legal_moves}"
      destination = @current_player.select_piece
      destination_coord = string_to_coord(destination)
      return destination_coord if legal_moves.include?(destination_coord)
    end
  end

  def update_board(start_coord, destination_coord)
    @board.change_pieces(start_coord, destination_coord)
  end

  def update_piece_move_history(origin_piece, destination_coord)
    return unless defined?(origin_piece.first_move)

    origin_piece.first_move.push(destination_coord)
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
    update_move_generator
    return unless @move_generator.no_player_moves?

    if @move_generator.check?
      display_checkmate
    else
      display_draw
    end
    true
  end

  def swap_player
    @current_player = if @current_player == @player_one
                        @player_two
                      else
                        @player_one
                      end
  end
end

# Next Pseudo Steps

  # Main Game logic missing:

      # Pawns