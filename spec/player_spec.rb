#spec/player_spec.rb

require './lib/game'
require './lib/moves/move_generator.rb'
require './lib/moves/en_passant_moves.rb'
require './lib/moves/castling.rb'
require './lib/moves/pawn_promotion_moves.rb'
require './lib/player'
require './lib/board'
require './lib/chess_notation.rb'
require './lib/square'
require './lib/pieces/piece'
require './lib/pieces/pawn'
require './lib/pieces/knight'
require './lib/pieces/king'
require './lib/pieces/rook'
require './lib/pieces/bishop'
require './lib/pieces/queen'

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
