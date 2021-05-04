#spec/en_passant_moves_spec.rb

require './lib/game'
require './lib/move_generator.rb'
require './lib/player'
require './lib/board'
require './lib/square'
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

  # describe '#find_x_coordinate_forward' do
  #   # Query sent to self
  #   context 'when piece is a white pawn' do

  #     it 'returns array with x coordinate minus one' do
  #       # Does this cover cases where origin piece is not a pawn but the destination coord meets the instance variable?
  #       # IT DOES NOT -- NEEDS Fix
  #       test_piece = Pawn.new([1, 3], 'white')
  #       test_coord = [2, 3]
  #       result_array = [1, 3]
  #       expect(test_en_passant.find_x_coordinate_forward(test_piece, test_coord)).to eq result_array
  #     end
  #   end

  # end

end
