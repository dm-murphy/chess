# frozen_string_literal: true

# Square space nodes for the Board grid
class Square
  attr_accessor :display, :pieces

  def initialize
    @display = '-'
    @pieces = nil
  end
end
