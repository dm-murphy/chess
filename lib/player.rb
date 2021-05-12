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
      result = gets.chomp
      return 'save' if save_game?(result)
      return result if valid_piece?(result)
    end
  end

  def save_game?(result)
    result.downcase == 'save' || result.downcase == "'save'"
  end

  def valid_piece?(piece)
    piece.length == 2 && piece[0][/([a-hA-H]+)/] && piece[1][/[1-8]/]
  end
end
