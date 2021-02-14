# frozen_string_literal: true

# lib/chess_spec.rb

class Board
  attr_accessor :grid, :white_king, :black_king

  def initialize
    @grid = Array.new(8) { Array.new(8, Square.new) }
    @white_king = King.new([0, 4], 'white')
    @black_king = King.new([7, 4], 'black')
    start_pieces
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

  def start_pieces
    @grid[0][0] = Rook.new([0, 0], 'white')
    @grid[0][1] = Knight.new([0, 1], 'white')
    @grid[0][6] = Knight.new([0, 6], 'white')
    @grid[7][1] = Knight.new([7, 1], 'black')
    @grid[7][6] = Knight.new([7, 6], 'black')
    @grid[0][4] = @white_king
    @grid[7][4] = @black_king
  end

  def change_pieces(old_coord, new_coord)
    piece = move_piece(old_coord, new_coord)
    update_piece(piece, new_coord)
    clean_square(old_coord)
  end

  def move_piece(old_coord, new_coord)
    piece = @grid[old_coord.first][old_coord.last]
    @grid[new_coord.first][new_coord.last] = piece
  end

  def update_piece(piece, new_coord)
    piece.coord = new_coord
    piece.possible_moves = []
    piece.find_moves
  end

  def clean_square(old_coord)
    @grid[old_coord.first][old_coord.last] = Square.new
  end
end

