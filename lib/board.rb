# frozen_string_literal: true

class Board
  attr_accessor :grid
  def initialize
    @grid = Array.new(8) { Array.new(8,"-") }
  end

  def display
    puts <<-HEREDOC
    
    7    #{@grid[7][0]}    #{@grid[7][1]}    #{@grid[7][2]}    #{@grid[7][3]}    #{@grid[7][4]}    #{@grid[7][5]}    #{@grid[7][6]}    #{@grid[7][7]}
    6    #{@grid[6][0]}    #{@grid[6][1]}    #{@grid[6][2]}    #{@grid[6][3]}    #{@grid[6][4]}    #{@grid[6][5]}    #{@grid[6][6]}    #{@grid[6][7]}
    5    #{@grid[5][0]}    #{@grid[5][1]}    #{@grid[5][2]}    #{@grid[5][3]}    #{@grid[5][4]}    #{@grid[5][5]}    #{@grid[5][6]}    #{@grid[5][7]}
    4    #{@grid[4][0]}    #{@grid[4][1]}    #{@grid[4][2]}    #{@grid[4][3]}    #{@grid[4][4]}    #{@grid[4][5]}    #{@grid[4][6]}    #{@grid[4][7]}
    3    #{@grid[3][0]}    #{@grid[3][1]}    #{@grid[3][2]}    #{@grid[3][3]}    #{@grid[3][4]}    #{@grid[3][5]}    #{@grid[3][6]}    #{@grid[3][7]}
    2    #{@grid[2][0]}    #{@grid[2][1]}    #{@grid[2][2]}    #{@grid[2][3]}    #{@grid[2][4]}    #{@grid[2][5]}    #{@grid[2][6]}    #{@grid[2][7]}
    1    #{@grid[1][0]}    #{@grid[1][1]}    #{@grid[1][2]}    #{@grid[1][3]}    #{@grid[1][4]}    #{@grid[1][5]}    #{@grid[1][6]}    #{@grid[1][7]}
    0    #{@grid[0][0]}    #{@grid[0][1]}    #{@grid[0][2]}    #{@grid[0][3]}    #{@grid[0][4]}    #{@grid[0][5]}    #{@grid[0][6]}    #{@grid[0][7]}
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
    # @grid[row][column].coord = @grid[end_row][end_column]
    #@grid[row][column].coord = [end_row][end_column]
    puts "This is @grid[row][column]: #{@grid[row][column]}"
    puts "This is @grid[end_row][end_column]: #{@grid[end_row][end_column]}"
    temp_node = @grid[row][column]
    p temp_node
    @grid[end_row][end_column] = temp_node
    @grid[row][column] = "-"
    p @grid[0][0]
    puts "This is the new @grid[end_row][end_column]: #{@grid[end_row][end_column]}"
    puts "This is the new @grid[row][column]: #{@grid[row][column]}"
  end
end