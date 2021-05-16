# frozen_string_literal: true

# Square space objects for the Board grid
class Square
  attr_accessor :display, :pieces

  def initialize
    @display = '-'
  end
end
