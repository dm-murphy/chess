# frozen_string_literal: true

# lib/chess_spec.rb

# Square space nodes for the Board grid
class Square
  attr_accessor :display, :pieces

  def initialize
    @display = '-'
    @pieces = nil
  end
end
