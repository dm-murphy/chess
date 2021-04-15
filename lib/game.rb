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
      
      # puts "#{@@current_player.pieces}"
      # swap_player
      # puts "#{@@current_player.pieces}"
      # swap_player
      origin_piece = ask_user_start
      legal_moves = generate_legal_moves(origin_piece)
      # move into generate_legal_moves

      # apply_en_passant(origin_piece, legal_moves)

      redo if legal_moves.empty?

      destination_coord = ask_user_destination(legal_moves)
      start_coord = origin_piece.coord
      test_new_update_pieces(origin_piece, destination_coord, start_coord)
      # update_pieces(origin_piece, destination_coord, start_coord)
      
      
      break if game_over?
    end
  end

  # def apply_en_passant(piece, moves)
  #   return if @en_passant_opponent_pieces.empty?
  #   return unless @en_passant_opponent_pieces.include?(piece)
  #   return if @move_generator.move_puts_self_in_check?(@en_passant_coordinate, piece)
  #   return if @move_generator.king_stays_in_check?(@en_passant_coordinate, piece)

  #   moves.push(@en_passant_coordinate)
  # end

  def test_new_update_pieces(origin_piece, destination_coord, start_coord)
    @move_generator.update_pieces(origin_piece, destination_coord, start_coord)
  end

  # def update_pieces(origin_piece, destination_coord, start_coord)
  #   update_captured_en_passant(destination_coord)
  #   check_en_passant(origin_piece, destination_coord, start_coord)
  #   update_piece_move_history(origin_piece, destination_coord)
  #   check_pawn_promotion(origin_piece, destination_coord, start_coord)
  #   update_board(start_coord, destination_coord)
  #   update_castling_rooks(destination_coord)
  # end

  # def update_captured_en_passant(destination_coord)
  #   return unless en_passant_captured?(destination_coord)

  #   en_passant_capture_coord = find_x_coordinate_forward(destination_coord)
  #   @board.clean_square(en_passant_capture_coord)
  # end

  # def en_passant_captured?(destination_coord)
  #   @en_passant_coordinate == destination_coord
  # end

  # def check_en_passant(origin_piece, destination_coord, start_coord)
  #   @en_passant_opponent_pieces = []
  #   @en_passant_coordinate = nil

  #   return unless origin_piece.class == Pawn
  #   return unless double_jump?(destination_coord, start_coord)

  #   find_en_passant_opponent_pieces(destination_coord)
  #   return if @en_passant_opponent_pieces.empty?

  #   coordinate = find_x_coordinate_backward(start_coord)
  #   @en_passant_coordinate = coordinate
  #   puts "#{@en_passant_coordinate} and #{@en_passant_opponent_pieces}"
  # end

  # def find_x_coordinate_backward(coord)
  #   x_change = if @current_player.pieces == 'white'
  #                1
  #              else
  #                -1
  #              end
  #   result_x = coord.first + x_change
  #   result_y = coord.last
  #   [result_x, result_y]
  # end

  # def find_x_coordinate_forward(coord)
  #   x_change = if @current_player.pieces == 'white'
  #                -1
  #              else
  #                1
  #              end
  #   result_x = coord.first + x_change
  #   result_y = coord.last
  #   [result_x, result_y]
  # end

  # def find_en_passant_opponent_pieces(destination_coord)
  #   left_side_coord = find_left_side_coord(destination_coord)
  #   right_side_coord = find_right_side_coord(destination_coord)

  #   left_side_piece = coords_to_grid_object(left_side_coord) unless left_side_coord.nil?
  #   right_side_piece = coords_to_grid_object(right_side_coord) unless right_side_coord.nil?

  #   add_possible_en_passant(left_side_piece)
  #   add_possible_en_passant(right_side_piece)
  # end

  # def add_possible_en_passant(piece)
  #   return unless piece.class == Pawn && piece.pieces == find_opponent

  #   @en_passant_opponent_pieces.push(piece)
  # end

  # def find_right_side_coord(destination_coord)
  #   result_x = destination_coord.first
  #   result_y = destination_coord.last + 1
  #   [result_x, result_y] if result_x.between?(0, 7) && result_y.between?(0, 7)
  # end

  # def find_left_side_coord(destination_coord)
  #   result_x = destination_coord.first
  #   result_y = destination_coord.last - 1
  #   [result_x, result_y] if result_x.between?(0, 7) && result_y.between?(0, 7)
  # end

  # def double_jump?(destination_coord, start_coord)
  #   result = subtract_coordinates(destination_coord, start_coord)
  #   result == [2, 0] || result == [-2, 0]
  # end

  # def find_opponent
  #   if @current_player.pieces == 'white'
  #     'black'
  #   elsif @current_player.pieces == 'black'
  #     'white'
  #   end
  # end

  # def subtract_coordinates(move, origin_coords)
  #   result_x = move[0] - origin_coords[0]
  #   result_y = move[1] - origin_coords[1]
  #   [result_x, result_y]
  # end

  # def check_pawn_promotion(origin_piece, destination_coord, start_coord)
  #   return unless origin_piece.class == Pawn
  #   return unless destination_coord.first == 7 || destination_coord.first == 0

  #   piece_selection_number = prompt_pawn_promotion
  #   promoted_piece_name = find_piece_class(piece_selection_number)
  #   pieces = origin_piece.pieces
  #   @board.promote_pawn(promoted_piece_name, start_coord, pieces)
  # end

  # def prompt_pawn_promotion
  #   puts "#{@current_player.name} select piece for pawn promotion:"
  #   puts "1 = Queen"
  #   puts "2 = Knight"
  #   puts "3 = Rook"
  #   puts "4 = Bishop"
  #   loop do
  #     string = @current_player.select_piece.to_i
  #     return string if string.between?(1, 4)
  #   end
  # end

  # def find_piece_class(piece_selection_number)
  #   hash = { "Queen" => 1, "Knight" => 2, "Rook" => 3, "Bishop" => 4 }
  #   hash.key(piece_selection_number)
  # end

  # def update_move_generator
  #   @move_generator = MoveGenerator.new(@board, @current_player)#, @en_passant_opponent_pieces, @en_passant_coordinate)
  # end

  def generate_legal_moves(origin_piece)
    # update_move_generator
    @move_generator.generate_legal_moves(origin_piece)
  end

  # def generate_castle_moves(origin_piece, legal_moves)
  #   @move_generator.find_castle_moves(origin_piece, legal_moves)
  # end

  # def update_castling_rooks(destination_coord)
  #   return unless @move_generator.castled?(destination_coord)

  #   rook_start_coord = @move_generator.rook_start(destination_coord)
  #   rook_destination_coord = @move_generator.rook_destination(destination_coord)
  #   update_board(rook_start_coord, rook_destination_coord)
  # end

  def display_user
    @board.show_grid
  end

  def ask_user_start
    loop do
      string = @move_generator.ask_move
      # string = @move_generator.current_player.select_piece
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

  # def update_board(start_coord, destination_coord)
  #   @board.change_pieces(start_coord, destination_coord)
  # end

  # def update_piece_move_history(origin_piece, destination_coord)
  #   return unless defined?(origin_piece.first_move)

  #   origin_piece.first_move.push(destination_coord)
  # end

  def display_draw
    @board.show_grid
    puts 'Draw.'
  end

  def display_checkmate
    @board.show_grid
    puts 'Checkmate.'
  end

  def game_over?
    # update_move_generator
    return unless @move_generator.no_player_moves?

    if @move_generator.check?
      display_checkmate
    else
      display_draw
    end
    true
  end

  # def swap_player
  #   @current_player = if @current_player == @player_one
  #                       @player_two
  #                     else
  #                       @player_one
  #                     end
  # end
end
