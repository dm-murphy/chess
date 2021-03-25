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
    @grid[7][0] = @black_queen_side_rook
    @grid[7][1] = Knight.new([7, 1], 'black')
    @grid[7][2] = Bishop.new([7, 2], 'black')
    @grid[7][3] = Queen.new([7, 3], 'black')
    @grid[7][4] = @black_king
    @grid[7][5] = Bishop.new([7, 5], 'black')
    @grid[7][6] = Knight.new([7, 6], 'black')
    @grid[7][7] = @black_king_side_rook
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
    # Add this

    ##### Don't forget about updating/removing these if changing class responsibility here
    piece.single_moves = []
    piece.find_single_moves
  end

  def move_piece_to_coords(piece, coords)
    @grid[coords.first][coords.last] = piece
  end

  def clean_square(old_coord)
    @grid[old_coord.first][old_coord.last] = Square.new
  end

  def empty_square?(row, column)
    @grid[row][column].class == Square
  end

  def occupied?(row, column)
    @grid[row][column].class != Square
  end


  # def path_finder(origin, destination)
  #   @origin_piece = origin
  #   destination_coord = destination
  #   @visited = [@origin_piece]
  #   build_path(destination_coord)
    
  #   # reset_path_finder
  # end

  def path_finder(origin, destination)
    @origin_piece = origin
    destination_coord = destination
    # @visited = [@origin_piece]
    # build_path(destination_coord)
    test_method(@origin_piece, destination_coord)
    # reset_path_finder
  end



  # def reset_path_finder
  #   @origin_piece = nil
  #   @destination_coord = nil
  #   @visitied = []
  # end

  # def build_path(destination_coord, queue = [@origin_piece])
  #   current = queue.last
  #   return if current.nil?
  #   return path_array(current) if current.coord == destination_coord

  #   current.single_moves.each do |move|
  #     next if @visited.include?(move)

  #     class_type = current.class
  #     piece_type = current.pieces
  #     piece_child = class_type.new(move, piece_type)
  #     current.children.push(piece_child)
  #     piece_child.parent = current
  #     @visited.push(piece_child.coord)
  #     queue.unshift(piece_child)
  #   end

  #   queue.pop
  #   build_path(destination_coord, queue)
  # end

  # def build_path(destination_coord, queue = [@origin_piece])
  #   current = queue.last
  #   return if current.nil?
  #   return path_array(current) if current.coord == destination_coord

  #   current.single_moves.each do |move|
  #     next if @visited.include?(move)

  #     class_type = current.class
  #     piece_type = current.pieces
  #     piece_child = class_type.new(move, piece_type)
  #     current.children.push(piece_child)
  #     piece_child.parent = current
  #     @visited.push(piece_child.coord)
  #     queue.unshift(piece_child)
  #   end

  #   queue.pop
  #   build_path(destination_coord, queue)
  # end

  def test_method(origin_piece, destination_coord)
    origin_piece.next_space_moves.each do |move|
      path = []
      path.push(origin_piece.coord)
      x = move[0]
      y = move[1]
      loop do 
        current_coord = path.last
        next_coord = [current_coord[0] + x, current_coord[1] + y]
        break if valid?(next_coord) == false

        path.push(next_coord)
        return path if next_coord == destination_coord
        # p path if next_coord == destination_coord
      end
      # path = []
      # path.push(new_coord)
      
      # next if new_coord == destination_coord
      
      # path = []
      # path.push(new_coord)
      # new_coord.parent = origin_piece
    end
  end

  def valid?(coord)
    # p coord
    # coord.map do |x, y|
    x = coord[0]
    y = coord[1]
    # p x
    # p y
    x.between?(0, 7) && y.between?(0, 7)
  end

  # def path_array(piece, array = [])
  #   array.unshift piece.coord
  #   return array if piece == @origin_piece

  #   path_array(piece.parent, array)
  # end
end
