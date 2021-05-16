# frozen_string_literal: true

require_relative 'game.rb'
require_relative 'moves/move_generator.rb'
require_relative 'moves/en_passant_moves.rb'
require_relative 'moves/castling.rb'
require_relative 'moves/pawn_promotion_moves.rb'
require_relative 'player.rb'
require_relative 'board.rb'
require_relative 'chess_notation.rb'
require_relative 'square.rb'
require_relative 'pieces/piece.rb'
require_relative 'pieces/pawn.rb'
require_relative 'pieces/knight.rb'
require_relative 'pieces/king.rb'
require_relative 'pieces/rook.rb'
require_relative 'pieces/bishop.rb'
require_relative 'pieces/queen.rb'

require 'yaml'
require 'time'

def start
  display_tutorial
  start_game_options
end

def display_tutorial
  puts <<-HEREDOC

  Welcome to Chess. 
  
  Players take turns choosing pieces and destinations.
  
  Select a piece by entering the column (a - h) followed by the row (1 - 8).
  
  E.g. the first player can select the kingside knight with g1
  or the leftmost pawn with a2.

  If a piece has legal moves available, the board will display them,
  otherwise the player must choose another piece.

  If a player is in check, they can only select pieces that take
  them out of check.

  HEREDOC
end

def start_game_options
  display_game_options
  option = ask_game_option
  start_game(option)
end

def display_game_options
  puts <<-HEREDOC
  ----------------------
  1 - New game
  2 - Load saved game
  (Type 'save' during the game to save your file)

  HEREDOC
end

def ask_game_option
  loop do
    option = gets.chomp
    return option if option_valid?(option)
  end
end

def option_valid?(option)
  option.length == 1 && option.to_i.between?(1, 2)
end

def start_game(option)
  if option == '1'
    game = Game.new
    game.start_turn
    start_game_options
  elsif option == '2'
    load_game
  end
end

def load_game
  puts 'Select the number for the saved .yml file you would like to load: '
  files = Dir.entries('saved_rounds')
  files.shift(2)
  sorted_files = files.sort_by{|l| Time.parse(l)}.reverse
  sorted_files.each_with_index do |file, index|
    print index
    print '  =  '
    print file
    puts
  end
  check_file(sorted_files)
end

def check_file(files)
  save_number = gets.chomp.to_i
  if save_number > -1
    print 'Loading... '
    loaded_file = files[save_number]
    puts loaded_file
    load_saved_round(loaded_file)
  else
    puts "That's not valid. Goodbye!"
  end
end

def load_saved_round(file)
  game = Game.new
  game.load(file)
  game.start_turn
  start_game_options
end

start