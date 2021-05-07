# frozen_string_literal: true

# lib/chess_spec.rb

class Player
  attr_accessor :name, :pieces

  def initialize(name, pieces)
    @name = name
    @pieces = pieces
  end

  def select_piece
    loop do
      piece = gets.chomp
      return piece if valid_piece?(piece)
    end
  end

  def valid_piece?(piece)
    piece.length == 2 && piece[0][/([a-hA-H]+)/] && piece[1] =~ /[1-8]/
  end
end
