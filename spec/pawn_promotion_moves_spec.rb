#spec/pawn_promotion_moves_spec.rb

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

describe PawnPromotionMoves do
  subject(:test_pawn_promo) { described_class.new(test_board, test_player_one, test_player_two) }
  let(:test_board) { Board.new }
  let(:test_player_one) { Player.new('Player 1', 'white') }
  let(:test_player_two) { Player.new('Player 2', 'black') }

  describe '#check_pawn_promotion' do
    # Script sent to self, test cases for different scenarios
    context 'when piece is not a pawn' do
      it 'returns nil' do
        test_piece = Knight.new([5, 1], 'white')
        test_destination = [7, 0]
        test_start = [5, 1]
        expect(test_pawn_promo.check_pawn_promotion(test_piece, test_destination, test_start)).to be nil
      end
    end

    context 'when a pawn destination x coordinate is not in the first or last row' do
      it 'returns nil' do
        test_piece = Pawn.new([5, 0], 'white')
        test_destination = [6, 0]
        test_start = [5, 0]
        expect(test_pawn_promo.check_pawn_promotion(test_piece, test_destination, test_start)).to be nil
      end
    end

    context 'when a pawn destination allows for promotion' do
      it 'sends #promote_pawn' do
        expect(test_pawn_promo).to receive(:promote_pawn)
        test_piece = Pawn.new([6, 0], 'white')
        test_destination = [7, 0]
        test_start = [6, 0]
        test_pawn_promo.check_pawn_promotion(test_piece, test_destination, test_start)
      end
    end
  end

# describe '#promote_pawn' do
# # Script sent to self
# end

# describe '#prompt_pawn_promotion' do
# # Loop script sent to self
# end

# describe '#display_pawn_promotion' do
# # Puts message
# end

# describe '#find_piece_class' do
# # Query sent to self
# end
end
  