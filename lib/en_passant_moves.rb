# frozen_string_literal: true

# lib/chess_spec.rb

# Responsible for providing en passant moves to MoveGenerator class
class EnPassantMoves < MoveGenerator
  attr_accessor :en_passant_opponent_pieces, :en_passant_coordinate

  # def initialize(board)#, current_player)
  #   @board = board
  #   # @current_player = current_player
  #   @en_passant_opponent_pieces = []
  #   @en_passant_coordinate = nil
  # end

  def setup_en_passant
    @en_passant_opponent_pieces = []
    @en_passant_coordinate = nil
  end
  
  def apply_en_passant(piece, moves)
    p @en_passant_opponent_pieces
    return if @en_passant_opponent_pieces.empty?
    return unless @en_passant_opponent_pieces.include?(piece)
    return if move_puts_self_in_check?(@en_passant_coordinate, piece)
    return if king_stays_in_check?(@en_passant_coordinate, piece)

    puts "PIZZA PIZZA"
    moves.push(@en_passant_coordinate)
  end

  def test_new_en_passant_script(origin_piece, destination_coord, start_coord)
    update_captured_en_passant(destination_coord)
    check_en_passant(origin_piece, destination_coord, start_coord)
  end

  def update_captured_en_passant(destination_coord)
    return unless en_passant_captured?(destination_coord)
    

    en_passant_capture_coord = find_x_coordinate_forward(destination_coord)
    p en_passant_capture_coord
    p @@current_player.name
    @board.clean_square(en_passant_capture_coord)
  end

  def en_passant_captured?(destination_coord)
    @en_passant_coordinate == destination_coord
  end

  def find_x_coordinate_forward(coord)
    x_change = if @@current_player.pieces == 'white'
                 -1
               else
                 1
               end
    result_x = coord.first + x_change
    result_y = coord.last
    [result_x, result_y]
  end

  def check_en_passant(origin_piece, destination_coord, start_coord)
    @en_passant_opponent_pieces = []
    @en_passant_coordinate = nil

    return unless origin_piece.class == Pawn
    return unless double_jump?(destination_coord, start_coord)

    find_en_passant_opponent_pieces(destination_coord)
    return if @en_passant_opponent_pieces.empty?

    coordinate = find_x_coordinate_backward(start_coord)
    @en_passant_coordinate = coordinate
    puts "#{@en_passant_coordinate} and #{@en_passant_opponent_pieces}"
  end

  def find_x_coordinate_backward(coord)
    x_change = if @@current_player.pieces == 'white'
                 1
               else
                 -1
               end
    result_x = coord.first + x_change
    result_y = coord.last
    [result_x, result_y]
  end

  def find_en_passant_opponent_pieces(destination_coord)
    left_side_coord = find_left_side_coord(destination_coord)
    right_side_coord = find_right_side_coord(destination_coord)

    left_side_piece = coords_to_grid_object(left_side_coord) unless left_side_coord.nil?
    right_side_piece = coords_to_grid_object(right_side_coord) unless right_side_coord.nil?

    add_possible_en_passant(left_side_piece)
    add_possible_en_passant(right_side_piece)
  end

  def add_possible_en_passant(piece)
    return unless piece.class == Pawn && piece.pieces == find_opponent

    @en_passant_opponent_pieces.push(piece)
  end

  def find_right_side_coord(destination_coord)
    result_x = destination_coord.first
    result_y = destination_coord.last + 1
    [result_x, result_y] if result_x.between?(0, 7) && result_y.between?(0, 7)
  end

  def find_left_side_coord(destination_coord)
    result_x = destination_coord.first
    result_y = destination_coord.last - 1
    [result_x, result_y] if result_x.between?(0, 7) && result_y.between?(0, 7)
  end

  def double_jump?(destination_coord, start_coord)
    result = subtract_coordinates(destination_coord, start_coord)
    result == [2, 0] || result == [-2, 0]
  end
end
