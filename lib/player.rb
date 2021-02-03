# frozen_string_literal: true

class Player
  attr_accessor :name, :pieces

  def initialize (name, pieces)
    @name = name
    @pieces = pieces
  end

end