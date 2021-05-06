#spec/en_passant_moves_spec.rb

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

describe EnPassantMoves do

  subject(:test_en_passant) { described_class.new(test_board) }
  let(:test_board) { Board.new }

# describe '#restart_en_passant' do
# # Command script
# end

# describe '#add_en_passant_move' do
# # Incoming command
# end

# describe '#update_en_passant' do
# # Script
# end

# describe '#update_captured_en_passant' do
# # Script
# end

  describe '#en_passant_captured?' do
    # Query sent to self
    context 'when piece is not a pawn but destination_coord matches @en_passant_coordinate' do
      it 'returns false' do
        test_piece = Rook.new([5, 7], 'white')
        test_destination = [5, 1]
        test_en_passant.instance_variable_set(:@en_passant_coordinate, [5, 1])
        expect(test_en_passant.en_passant_captured?(test_piece, test_destination)).to be false
      end
    end

    context 'when piece is a pawn but destination_coord does not match @en_passant_coordinate' do
      it 'returns false' do
        test_piece = Pawn.new([4, 0], 'white')
        test_destination = [5, 0]
        test_en_passant.instance_variable_set(:@en_passant_coordinate, [5, 1])
        expect(test_en_passant.en_passant_captured?(test_piece, test_destination)).to be false
      end
    end

    context 'when piece is a pawn and destination_coord matches @en_passant_coordinate' do
      it 'returns true' do
        test_piece = Pawn.new([4, 0], 'white')
        test_destination = [5, 1]
        test_en_passant.instance_variable_set(:@en_passant_coordinate, [5, 1])
        expect(test_en_passant.en_passant_captured?(test_piece, test_destination)).to be true
      end
    end
  end

  describe '#find_captured_pawn_coordinate' do
    # Query sent to self
    context 'when piece is a white pawn' do

      it 'returns array with destination x coordinate minus one' do
        test_piece = Pawn.new([4, 0], 'white')
        test_coord = [5, 1]
        result_array = [4, 1]
        expect(test_en_passant.find_captured_pawn_coordinate(test_piece, test_coord)).to eq result_array
      end
    end

    context 'when piece is a black pawn' do

      it 'returns array with destination x coordinate minus one' do
        test_piece = Pawn.new([3, 1], 'black')
        test_coord = [2, 0]
        result_array = [3, 0]
        expect(test_en_passant.find_captured_pawn_coordinate(test_piece, test_coord)).to eq result_array
      end
    end
  end

  describe '#remove_pawn' do
    # Outgoing command, test message is sent
    it 'sends message to Board class to clean the square' do
      expect(test_board).to receive(:clean_square)
      test_coord = [3, 0]
      test_en_passant.remove_pawn(test_coord)
    end
  end

# describe '#check_en_passant' do
# # Script
# end

  describe '#double_jump?' do
    # Query sent to self
    context 'when piece is not a pawn' do

      it 'returns nil' do
        test_piece = Rook.new([0, 0], 'white')
        test_destination = [3, 0]
        test_start = [0, 0]
        expect(test_en_passant.double_jump?(test_piece, test_destination, test_start)).to be nil
      end
    end

    context 'when piece is a white pawn' do

      it 'returns true' do
        test_piece = Pawn.new([1, 1], 'white')
        test_destination = [3, 1]
        test_start = [1, 1]
        expect(test_en_passant.double_jump?(test_piece, test_destination, test_start)).to be true
      end
    end

    context 'when piece is a black pawn' do

      it 'returns true' do
        test_piece = Pawn.new([6, 1], 'black')
        test_destination = [4, 1]
        test_start = [6, 1]
        expect(test_en_passant.double_jump?(test_piece, test_destination, test_start)).to be true
      end
    end
  end

# describe '#find_en_passant_opponent_pieces' do
# # Script
# end

  describe '#find_left_side_coord' do
    # Query sent to self
    context 'when white pawn destination coord is [3, 1]' do

      it 'returns [3, 0]' do
        test_coord = [3, 1]
        result_array = [3, 0]
        expect(test_en_passant.find_left_side_coord(test_coord)).to eq result_array
      end
    end

    context 'when black pawn destination coord is [4, 1]' do

      it 'returns [4, 0]' do
        test_coord = [4, 1]
        result_array = [4, 0]
        expect(test_en_passant.find_left_side_coord(test_coord)).to eq result_array
      end
    end
  end

  describe '#find_right_side_coord' do
    # Query sent to self
    context 'when white pawn destination coord is [3, 1]' do

      it 'returns [3, 0]' do
        test_coord = [3, 1]
        result_array = [3, 2]
        expect(test_en_passant.find_right_side_coord(test_coord)).to eq result_array
      end
    end

    context 'when black pawn destination coord is [4, 1]' do

      it 'returns [4, 0]' do
        test_coord = [4, 1]
        result_array = [4, 2]
        expect(test_en_passant.find_right_side_coord(test_coord)).to eq result_array
      end
    end
  end

  describe '#add_possible_en_passant' do
  # Outgoing command
    let(:test_variable) { test_en_passant.instance_variable_set(:@en_passant_opponent_pieces, []) }
    
    context 'when possible_opponent_piece is a pawn of different piece type then player_piece' do

      it 'sends message to instance variable @en_passant_opponent_pieces' do
        expect(test_variable).to receive(:push)
        test_player_piece = Pawn.new([1, 1], 'white')
        test_possible_opponent_piece = Pawn.new([0, 3], 'black')
        test_en_passant.add_possible_en_passant(test_player_piece, test_possible_opponent_piece)
      end
    end

    context 'when possible_opponent_piece is a pawn of matching piece type to player_piece' do

      it 'returns nil' do
        test_player_piece = Pawn.new([1, 1], 'white')
        test_possible_opponent_piece = Pawn.new([0, 3], 'white')
        expect(test_en_passant.add_possible_en_passant(test_player_piece, test_possible_opponent_piece)).to be nil
      end
    end

    context 'when possible_opponent_piece is not a pawn' do

      it 'returns nil' do
        test_player_piece = Pawn.new([1, 1], 'white')
        test_possible_opponent_piece = Rook.new([0, 3], 'black')
        expect(test_en_passant.add_possible_en_passant(test_player_piece, test_possible_opponent_piece)).to be nil
      end
    end
  end

  # describe '#add_en_passant_coordinate' do
  # # Script
  # end

  describe '#find_new_en_passant_coordinate' do
    # Query sent to self
    context 'when piece is a white pawn' do

      it 'returns array with start x coordinate plus one' do
        test_piece = Pawn.new([1, 1], 'white')
        test_coord = [1, 1]
        result_array = [2, 1]
        expect(test_en_passant.find_new_en_passant_coordinate(test_piece, test_coord)).to eq result_array
      end
    end

    context 'when piece is a black pawn' do

      it 'returns array with start x coordinate minus one' do
        test_piece = Pawn.new([6, 1], 'black')
        test_coord = [6, 1]
        result_array = [5, 1]
        expect(test_en_passant.find_new_en_passant_coordinate(test_piece, test_coord)).to eq result_array
      end
    end
  end
end
