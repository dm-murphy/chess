# frozen_string_literal: true

# lib/chess_spec.rb

class Board
  attr_accessor :grid, :white_king, :white_king_side_rook, :white_queen_side_rook, :black_king, :black_king_side_rook, :black_queen_side_rook

  def initialize
    @grid = Array.new(8) { Array.new(8, Square.new) }
    @white_king = King.new([0, 4], 'white')
    @white_king_side_rook = Rook.new([0, 7], 'white')
    @white_queen_side_rook = Rook.new([0, 0], 'white')
    @black_king = King.new([7, 4], 'black')
    @black_king_side_rook = Rook.new([7, 7], 'black')
    @black_queen_side_rook = Rook.new([7, 0], 'black')
    @origin_piece = nil
    @visited = []
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
    @grid[0][0] = @white_queen_side_rook
    @grid[0][1] = Knight.new([0, 1], 'white')
    @grid[0][2] = Bishop.new([0, 2], 'white')
    @grid[0][3] = Queen.new([0, 3], 'white')
    @grid[0][4] = @white_king
    @grid[0][5] = Bishop.new([0, 5], 'white')
    @grid[0][6] = Knight.new([0, 6], 'white')
    @grid[0][7] = @white_king_side_rook
    @grid[1][0] = Pawn.new([1, 0], 'white')
    @grid[7][0] = @black_queen_side_rook
    @grid[7][1] = Knight.new([7, 1], 'black')
    @grid[7][2] = Bishop.new([7, 2], 'black')
    @grid[7][3] = Queen.new([7, 3], 'black')
    @grid[7][4] = @black_king
    @grid[7][5] = Bishop.new([7, 5], 'black')
    @grid[7][6] = Knight.new([7, 6], 'black')
    @grid[7][7] = @black_king_side_rook
    @grid[6][1] = Pawn.new([6, 1], 'black')
    @grid[6][7] = Pawn.new([6, 7], 'black')
  end

  def promote_pawn(promoted_piece_name, start_coord, pieces)
    clean_square(start_coord)
    piece_class = Object.const_get promoted_piece_name
    @grid[start_coord.first][start_coord.last] = piece_class.new(start_coord, pieces)
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
    piece.find_possible_moves
  end

  def move_piece_to_coords(piece, coords)
    @grid[coords.first][coords.last] = piece
  end

  def clean_square(old_coord)
    @grid[old_coord.first][old_coord.last] = Square.new
  end

  def empty_space?(coord)
    @grid[coord.first][coord.last].class == Square
  end

  # Not used anymore?
  def empty_square?(row, column)
    @grid[row][column].class == Square
  end
  #

  def occupied?(row, column)
    @grid[row][column].class != Square
  end

  def build_path(origin_piece, destination_coord)
    origin_piece.next_space_moves.each do |move|
      path = []
      path.push(origin_piece.coord)
      x = move[0]
      y = move[1]
      loop do
        current_coord = path.last
        next_coord = [current_coord[0] + x, current_coord[1] + y]
        break unless valid?(next_coord)

        path.push(next_coord)
        return path if next_coord == destination_coord
      end
    end
  end

  def valid?(coord)
    x = coord[0]
    y = coord[1]
    x.between?(0, 7) && y.between?(0, 7)
  end
end
