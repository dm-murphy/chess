# frozen_string_literal: true

# lib/chess_spec.rb

class Game
  def initialize(board = Board.new)#, player_one = Player.new('white'), player_two = Player.new('black'))
    @board = board
    #@player_one = player_one
    #@player_two = player_two
  end

  def start
    p @board.display
  end
end