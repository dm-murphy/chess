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

  def load(file)
    restored_round = YAML.load(File.read("saved_rounds/#{file}"))

    @board = restored_round[:board]
    @player_one = restored_round[:player_one]
    @player_two = restored_round[:player_two]
    @move_generator = restored_round[:move_generator]
  end

  def start_turn
    loop do
      @board.show_grid
      result = @move_generator.ask_user
      redo if user_saved_game?(result)

      origin_piece = @move_generator.find_origin_piece(result)
      redo if not_player_piece?(origin_piece)

      legal_moves = @move_generator.generate_legal_moves(origin_piece)
      redo if illegal_piece?(legal_moves)

      destination_coord = @move_generator.ask_user_destination(legal_moves)
      end_turn(origin_piece, destination_coord)
      break if game_over?
    end
  end

  def end_turn(origin_piece, destination_coord)
    start_coord = origin_piece.coord
    @move_generator.update_pieces(origin_piece, destination_coord, start_coord)
    @move_generator.swap_player
  end

  def user_saved_game?(result)
    return unless result == 'save'

    save_game
    true
  end

  def save_game
    time = Time.now

    Dir.mkdir('saved_rounds') unless Dir.exist? 'saved_rounds'

    filename = "saved_rounds/#{time}.yml"

    File.open(filename,'w') do |file|
      file.write self.to_yaml
    end
    puts "Saved game: #{filename}"
  end

  def to_yaml
    YAML.dump ({
      board: @board,
      player_one: @player_one,
      player_two: @player_two,
      move_generator: @move_generator
    })
  end

  def not_player_piece?(origin_piece)
    return unless origin_piece.nil?

    puts 'Not a player piece'
    true
  end

  def illegal_piece?(legal_moves)
    return unless legal_moves.empty?

    puts 'No legal moves'
    puts 'King in check' if @move_generator.check?
    true
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
