# frozen_string_literal: true

class Board
  attr_accessor :grid
  def initialize
    # @grid = Array.new(8) { Array.new(8, "-") }
    @grid = Array.new(8) { Array.new(8, Square.new) }
  end

  def show_grid
    puts <<-HEREDOC
    
    7    #{@grid[7][0].display}    #{@grid[7][1].display}    #{@grid[7][2].display}    #{@grid[7][3].display}    #{@grid[7][4].display}    #{@grid[7][5].display}    #{@grid[7][6].display}    #{@grid[7][7].display}
    6    #{@grid[6][0].display}    #{@grid[6][1].display}    #{@grid[6][2].display}    #{@grid[6][3].display}    #{@grid[6][4].display}    #{@grid[6][5].display}    #{@grid[6][6].display}    #{@grid[6][7].display}
    5    #{@grid[5][0].display}    #{@grid[5][1].display}    #{@grid[5][2].display}    #{@grid[5][3].display}    #{@grid[5][4].display}    #{@grid[5][5].display}    #{@grid[5][6].display}    #{@grid[5][7].display}
    4    #{@grid[4][0].display}    #{@grid[4][1].display}    #{@grid[4][2].display}    #{@grid[4][3].display}    #{@grid[4][4].display}    #{@grid[4][5].display}    #{@grid[4][6].display}    #{@grid[4][7].display}
    3    #{@grid[3][0].display}    #{@grid[3][1].display}    #{@grid[3][2].display}    #{@grid[3][3].display}    #{@grid[3][4].display}    #{@grid[3][5].display}    #{@grid[3][6].display}    #{@grid[3][7].display}
    2    #{@grid[2][0].display}    #{@grid[2][1].display}    #{@grid[2][2].display}    #{@grid[2][3].display}    #{@grid[2][4].display}    #{@grid[2][5].display}    #{@grid[2][6].display}    #{@grid[2][7].display}
    1    #{@grid[1][0].display}    #{@grid[1][1].display}    #{@grid[1][2].display}    #{@grid[1][3].display}    #{@grid[1][4].display}    #{@grid[1][5].display}    #{@grid[1][6].display}    #{@grid[1][7].display}
    0    #{@grid[0][0].display}    #{@grid[0][1].display}    #{@grid[0][2].display}    #{@grid[0][3].display}    #{@grid[0][4].display}    #{@grid[0][5].display}    #{@grid[0][6].display}    #{@grid[0][7].display}
         0    1    2    3    4    5    6    7
    
    HEREDOC

  end

  def start_pieces_knight
    # Display test method to start a white knight piece in correct position
    
    # This seems wrong
    @grid[0][1] = Knight.new([0, 1], "white")

    # Would all knight objects just be made at once?
    # How do I access just this one object then? 
  end
  
  # So in board class, I'm making all the white and black pieces as nodes right from the start
  # Too many pieces to have instance variables for each object
  # Can the board object coordinates work instead? How do I take that knight object node and reassign its coordinates?

  def change_piece(row, column, end_row, end_column)
    # puts "This is @grid[row][column]: #{@grid[row][column]}"
    # puts "This is @grid[end_row][end_column]: #{@grid[end_row][end_column]}"
    temp_node = @grid[row][column]
    @grid[end_row][end_column] = temp_node
    @grid[row][column] = Square.new
    # puts "This is the new @grid[end_row][end_column]: #{@grid[end_row][end_column]}"
    # puts "This is the new @grid[row][column]: #{@grid[row][column]}"
  end
end
