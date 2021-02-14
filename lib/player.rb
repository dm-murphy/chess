# frozen_string_literal: true

# lib/chess_spec.rb

class Player
  attr_accessor :name, :pieces

  def initialize(name, pieces)
    @name = name
    @pieces = pieces
  end
  
  def select_piece
    gets.chomp
  end
end
