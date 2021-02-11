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
    # Add display for rules and how to input board positions
    # Add option to Load game file
    start_turn
  end

  def start_turn
    loop do
      display_user
      start_coord = ask_user_start
      
      node = coords_to_node(start_coord)

      moves = find_node_moves(node)
      
      legal_moves = find_legal_moves(moves, node)
      p legal_moves
      
      destination_coord = ask_user_destination(legal_moves)
      update_board(start_coord, destination_coord)
      break if game_over?

      swap_player
    end
  end

  def display_user
    @board.show_grid
    check_message
    puts "#{@current_player.name} choose a piece"
    puts
  end

  def check_message
    if check_alert == true
      puts "#{@current_player.name} (#{@current_player.pieces.capitalize}) is in CHECK"
    end
  end
  
  def check_alert
    if @current_player.pieces == 'white'
      king = @board.white_king.coord
      in_check?(king, 'black')
    elsif @current_player.pieces == 'black'
      king = @board.black_king.coord
      in_check?(king, 'white')
    end
  end

  def in_check?(coord, opponent)
    opponent_pieces = find_opponent_pieces(opponent)
    opponent_moves = find_opponent_moves(opponent_pieces).flatten(1)
    # opponent_moves = find_opponent_moves(opponent_pieces)
    coord_in_check?(coord, opponent_moves)
  end

  def find_opponent_pieces(opponent)
    opponent_pieces = []
    @board.grid.map do |row|
      row.map do |piece|
        opponent_pieces.push(piece) if piece.pieces == opponent
      end
    end
    opponent_pieces
  end

  def find_opponent_moves(opponent_pieces)
    opponent_pieces.map do |piece|
      piece.possible_moves
    end
  end

  def coord_in_check?(coord, opponent_moves)
    opponent_moves.map do |move|
      return true if move == coord
    end
    false
  end

  def ask_user_start
    loop do
      current_piece = @current_player.prompt_piece
      current_coord = string_to_array(current_piece)
      return current_coord if check_piece(current_coord)
    end
  end

  def string_to_array(position)
    position.chomp.split('').map(&:to_i)
  end

  def check_piece(current_coord)
    node = coords_to_node(current_coord)
    true if node.pieces == @current_player.pieces && node.possible_moves.empty? == false
  end

  def coords_to_node(coord)
    row = coord.first
    column = coord.last
    @board.grid[row][column]
  end

  def find_node_moves(node)
    node.possible_moves
  end

  def find_legal_moves(moves, node)
    legal_moves = []

    moves.map do |move|
      legal_moves.push(move) unless illegal_move?(move, node)
    end
    legal_moves
  end

  def illegal_move?(move, node)
    occupied_by_current_player?(move) || king_moves_into_check?(move, node)  #|| leaves_king_in_check(move, node)
    # Still need:
      # Exposes_king_to_check?
        # Which also sees if a capture on the move prevents that exposure
      # Prevent other piece moves while in check
  end

  def occupied_by_current_player?(move)
    node = coords_to_node(move)
    node.pieces == @current_player.pieces
  end

  def king_moves_into_check?(move, node)
    if white_king?(node)
      in_check?(move, 'black')
    elsif black_king?(node)
      in_check?(move, 'white')
    end
  end

  def white_king?(node)
    node == @board.white_king
  end

  def black_king?(node)
    node == @board.black_king
  end

  # def leaves_king_in_check(move, node)
  #   # put king_moves_into_check? inside here?
  # end



  # def in_check?(coord, opponent)
  #   opponent_pieces = find_opponent_pieces(opponent)
  #   opponent_moves = find_opponent_moves(opponent_pieces).flatten(1)
  #   # opponent_moves = find_opponent_moves(opponent_pieces)
  #   coord_in_check?(coord, opponent_moves)
  # end

  # def find_opponent_pieces(opponent)
  #   opponent_pieces = []
  #   @board.grid.map do |row|
  #     row.map do |piece|
  #       opponent_pieces.push(piece) if piece.pieces == opponent
  #     end
  #   end
  #   opponent_pieces
  # end

  # def find_opponent_moves(opponent_pieces)
  #   opponent_pieces.map do |piece|
  #     piece.possible_moves
  #   end
  # end

  # def coord_in_check?(coord, opponent_moves)
  #   opponent_moves.map do |move|
  #     return true if move == coord
  #   end
  #   false
  # end






  
  def ask_user_destination(legal_moves)
    loop do
      puts "Choose a destination: #{legal_moves}"
      destination = @current_player.prompt_piece
      destination_coord = string_to_array(destination)
      return destination_coord if check_destination(destination_coord, legal_moves)
    end
  end

  def check_destination(destination_coord, legal_moves)
    true if legal_moves.include?(destination_coord)
  end

  def update_board(start_coord, destination_coord)
    @board.change_pieces(start_coord, destination_coord)
  end

  def game_over?
    # Hard code false for now
    # Conditional check for Draw or Checkmate
    false
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

    # Write tests:
        
        # White King cannot put self into check
        # Black King cannot put self into check
        # White is notified if in check
        # Black is notified if in check
        # Knight can capture opponent Knight
        # King can capture opponent Knight

    # Main Game logic missing:


# Still need:
      # Exposes_king_to_check?
        # which also sees if a capture on the move prevents that exposure
        
      # Current Player can't make any other move than to get out of check 
         # Don't allow user to select a piece with no moves... ahead of time?
    
      # Prevent moves where another piece along the way is blocking path

      # Computer checks for checkmate/draw and if true displays result