#spec/piece_spec.rb

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

describe Piece do

  describe '#find_possible_moves' do
    # Outgoing command
    context 'when a white rook coordinates are valid for 14 positions' do
      let(:test_rook) { Rook.new([0, 0], 'white') }
      let(:test_possible_moves) { test_rook.instance_variable_set(:@possible_moves, []) }

      it 'sends message to @possible_moves 14 times' do
        expect(test_possible_moves).to receive(:push).exactly(14)
        test_rook.find_possible_moves
      end
    end

    context 'when a black rook coordinates are valid for 14 positions' do
      let(:test_rook) { Rook.new([3, 3], 'black') }
      let(:test_possible_moves) { test_rook.instance_variable_set(:@possible_moves, []) }

      it 'sends message to @possible_moves 14 times' do
        expect(test_possible_moves).to receive(:push).exactly(14)
        test_rook.find_possible_moves
      end
    end
  end

  describe '#valid_coordinate?' do
    # Query sent to self
    context 'when an x coordinate is out of bounds' do
      let(:test_rook) { Rook.new([0, 0], 'white') }

      it 'returns false' do
        test_x = -1
        test_y = 0
        expect(test_rook.valid_coordinate?(test_x, test_y)).to be false
      end
    end

    context 'when a y coordinate is out of bounds' do
      let(:test_rook) { Rook.new([0, 3], 'white') }

      it 'returns false' do
        test_x = 0
        test_y = 9
        expect(test_rook.valid_coordinate?(test_x, test_y)).to be false
      end
    end

    context 'when x and y coordinates are in bounds' do
      let(:test_rook) { Rook.new([0, 0], 'white') }

      it 'returns true' do
        test_x = 4
        test_y = 0
        expect(test_rook.valid_coordinate?(test_x, test_y)).to be true
      end
    end
  end
end
