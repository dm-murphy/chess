#spec/player_spec.rb

require './lib/game'
require './lib/move_generator.rb'
require './lib/chess_notation.rb'
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

describe Player do

# describe '#select_piece' do
# # Loop script
# end

# describe '#save_game?' do
# # Query sent to self
# end

  describe '#valid_piece?' do
    let(:test_player) { Player.new('Player 1', 'white') }

    context "when piece string entry is 'a2'" do    
      it 'is truthy / does not return nil' do
        test_piece = 'a2'
        expect(test_player.valid_piece?(test_piece)).not_to be nil
      end
    end

    context "when piece string entry is 'a9'" do
      it 'returns nil' do
        test_piece = 'a9'
        expect(test_player.valid_piece?(test_piece)).to be nil
      end
    end

    context "when piece string entry is 'z3'" do
      it 'returns nil' do
        test_piece = 'z3'
        expect(test_player.valid_piece?(test_piece)).to be nil
      end
    end

    context "when piece string entry is 'b12'" do
      it 'returns false' do
        test_piece = 'b12'
        expect(test_player.valid_piece?(test_piece)).to be false
      end
    end
  end
end
