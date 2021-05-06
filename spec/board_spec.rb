#spec/board_spec.rb

require './lib/game'
require './lib/move_generator.rb'
require './lib/player'
require './lib/board'
require './lib/square'
require './lib/piece'
require './lib/pawn'
require './lib/knight'
require './lib/king'
require './lib/rook'
require './lib/bishop'
require './lib/queen'
require './lib/en_passant_moves.rb'
require './lib/castling.rb'
require './lib/pawn_promotion_moves.rb'

describe Board do
  # describe 'show_grid' do
  # # Puts message
  # end
  
  # describe 'change_piece' do
  # # Script sent to self
  # end
  
  # describe 'move_piece' do
  # # Command sent to self
  # end
  
  # describe 'update_piece' do
  # # Script of outgoing commands
  # end

  # describe 'clean_square' do
  # # Command sent to self
  # end

  # describe 'move_piece_to_coords' do
  # # Command sent to self
  # end

  # describe 'empty_space?' do
  # # Query sent to self
  # end

  # describe 'occupied?' do
  # # Query sent to self
  # end

  describe 'build_path' do
    subject(:test_board) { described_class.new }
    # Test cases where pieces move more than one space away and has a path of multiple coordinates in between
    # Test King cases to make sure King takes direct route one space away
    # Queen uses same move methods as Rook and Bishop combined

    context 'when a Rook moves north from one end of board to opposite end' do

      it 'returns full path of coordinates from origin to destination' do
        test_piece = Rook.new([0, 0], 'white')
        test_destination_coord = [7, 0]
        test_path = [[0, 0], [1, 0], [2, 0], [3, 0], [4, 0], [5, 0], [6, 0], [7, 0]]
        expect(test_board.build_path(test_piece, test_destination_coord)).to eq test_path
      end
    end

    context 'when a Rook moves south from one end of board to opposite end' do

      it 'returns full path of coordinates from origin to destination' do
        test_piece = Rook.new([7, 0], 'white')
        test_destination_coord = [0, 0]
        test_path = [[7, 0], [6, 0], [5, 0], [4, 0], [3, 0], [2, 0], [1, 0], [0, 0]]
        expect(test_board.build_path(test_piece, test_destination_coord)).to eq test_path
      end
    end

    context 'when a Rook moves east from one end of board to opposite end' do

      it 'returns full path of coordinates from origin to destination' do
        test_piece = Rook.new([0, 0], 'white')
        test_destination_coord = [0, 7]
        test_path = [[0, 0], [0, 1], [0, 2], [0, 3], [0, 4], [0, 5], [0, 6], [0, 7]]
        expect(test_board.build_path(test_piece, test_destination_coord)).to eq test_path
      end
    end

    context 'when a Rook moves west from one end of board to opposite end' do

      it 'returns full path of coordinates from origin to destination' do
        test_piece = Rook.new([0, 7], 'white')
        test_destination_coord = [0, 0]
        test_path = [[0, 7], [0, 6], [0, 5], [0, 4], [0, 3], [0, 2], [0, 1], [0, 0]]
        expect(test_board.build_path(test_piece, test_destination_coord)).to eq test_path
      end
    end

    context 'when a Bishop moves northeast from one end of board to opposite end' do

      it 'returns full path of coordinates from origin to destination' do
        test_piece = Bishop.new([0, 2], 'white')
        test_destination_coord = [5, 7]
        test_path = [[0, 2], [1, 3], [2, 4], [3, 5], [4, 6], [5, 7]]
        expect(test_board.build_path(test_piece, test_destination_coord)).to eq test_path
      end
    end

    context 'when a Bishop moves northwest from one end of board to opposite end' do

      it 'returns full path of coordinates from origin to destination' do
        test_piece = Bishop.new([0, 5], 'white')
        test_destination_coord = [5, 0]
        test_path = [[0, 5], [1, 4], [2, 3], [3, 2], [4, 1], [5, 0]]
        expect(test_board.build_path(test_piece, test_destination_coord)).to eq test_path
      end
    end

    context 'when a Bishop moves southeast from one end of board to opposite end' do

      it 'returns full path of coordinates from origin to destination' do
        test_piece = Bishop.new([5, 0], 'white')
        test_destination_coord = [0, 5]
        test_path = [[5, 0], [4, 1], [3, 2], [2, 3], [1, 4], [0, 5]]
        expect(test_board.build_path(test_piece, test_destination_coord)).to eq test_path
      end
    end

    context 'when a Bishop moves southwest from one end of board to opposite end' do

      it 'returns full path of coordinates from origin to destination' do
        test_piece = Bishop.new([5, 7], 'white')
        test_destination_coord = [0, 2]
        test_path = [[5, 7], [4, 6], [3, 5], [2, 4], [1, 3], [0, 2]]
        expect(test_board.build_path(test_piece, test_destination_coord)).to eq test_path
      end
    end

    context 'when a King moves north' do

      it 'returns path of two coordinates from origin to destination' do
        test_piece = King.new([3, 3], 'white')
        test_destination_coord = [4, 3]
        test_path = [[3, 3], [4, 3]]
        expect(test_board.build_path(test_piece, test_destination_coord)).to eq test_path
      end
    end

    context 'when a King moves northeast' do

      it 'returns path of two coordinates from origin to destination' do
        test_piece = King.new([3, 3], 'white')
        test_destination_coord = [4, 4]
        test_path = [[3, 3], [4, 4]]
        expect(test_board.build_path(test_piece, test_destination_coord)).to eq test_path
      end
    end

    context 'when a King moves east' do

      it 'returns path of two coordinates from origin to destination' do
        test_piece = King.new([3, 3], 'white')
        test_destination_coord = [3, 4]
        test_path = [[3, 3], [3, 4]]
        expect(test_board.build_path(test_piece, test_destination_coord)).to eq test_path
      end
    end

    context 'when a King moves southeast' do

      it 'returns path of two coordinates from origin to destination' do
        test_piece = King.new([3, 3], 'white')
        test_destination_coord = [2, 4]
        test_path = [[3, 3], [2, 4]]
        expect(test_board.build_path(test_piece, test_destination_coord)).to eq test_path
      end
    end

    context 'when a King moves south' do

      it 'returns path of two coordinates from origin to destination' do
        test_piece = King.new([3, 3], 'white')
        test_destination_coord = [2, 3]
        test_path = [[3, 3], [2, 3]]
        expect(test_board.build_path(test_piece, test_destination_coord)).to eq test_path
      end
    end

    context 'when a King moves southwest' do

      it 'returns path of two coordinates from origin to destination' do
        test_piece = King.new([3, 3], 'white')
        test_destination_coord = [2, 2]
        test_path = [[3, 3], [2, 2]]
        expect(test_board.build_path(test_piece, test_destination_coord)).to eq test_path
      end
    end

    context 'when a King moves west' do

      it 'returns path of two coordinates from origin to destination' do
        test_piece = King.new([3, 3], 'white')
        test_destination_coord = [3, 2]
        test_path = [[3, 3], [3, 2]]
        expect(test_board.build_path(test_piece, test_destination_coord)).to eq test_path
      end
    end

    context 'when a King moves northwest' do

      it 'returns path of two coordinates from origin to destination' do
        test_piece = King.new([3, 3], 'white')
        test_destination_coord = [4, 2]
        test_path = [[3, 3], [4, 2]]
        expect(test_board.build_path(test_piece, test_destination_coord)).to eq test_path
      end
    end
  end

  # describe 'valid?' do
  # # Query sent to self
  # end

  # describe 'promote_pawn' do
  # # Script of commands
  # end
end
