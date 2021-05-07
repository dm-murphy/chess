#spec/pawn_spec.rb

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

describe Pawn do

  describe '#find_possible_moves' do

    context 'when a white pawn with no first move has coordinates valid for 3 positions' do
      let(:test_pawn) { Pawn.new([1, 0], 'white') }
      let(:test_possible_moves) { test_pawn.instance_variable_set(:@possible_moves, []) }

      it 'sends message to @possible_moves 3 times' do
        expect(test_possible_moves).to receive(:push).exactly(3)
        test_pawn.find_possible_moves
      end
    end

    context 'when a white pawn with a first move has coordinates valid for 2 positions' do
      let(:test_pawn) { Pawn.new([2, 0], 'white') }
      let(:test_possible_moves) { test_pawn.instance_variable_set(:@possible_moves, []) }
      let(:test_first_move) { test_pawn.instance_variable_set(:@first_move, [[2, 0]]) }

      it 'sends message to @possible_moves 2 times' do
        expect(test_possible_moves).to receive(:push).exactly(2)
        test_pawn.first_move = test_first_move
        test_pawn.find_possible_moves
      end
    end

    context 'when a black pawn with no first move has coordinates valid for 4 positions' do
      let(:test_pawn) { Pawn.new([6, 1], 'black') }
      let(:test_possible_moves) { test_pawn.instance_variable_set(:@possible_moves, []) }

      it 'sends message to @possible_moves 4 times' do
        expect(test_possible_moves).to receive(:push).exactly(4)
        test_pawn.find_possible_moves
      end
    end

    context 'when a black pawn with a first move has coordinates valid for 3 positions' do
      let(:test_pawn) { Pawn.new([5, 1], 'black') }
      let(:test_possible_moves) { test_pawn.instance_variable_set(:@possible_moves, []) }
      let(:test_first_move) { test_pawn.instance_variable_set(:@first_move, [[5, 1]]) }

      it 'sends message to @possible_moves 3 times' do
        expect(test_possible_moves).to receive(:push).exactly(3)
        test_pawn.first_move = test_first_move
        test_pawn.find_possible_moves
      end
    end
  end

# describe '#find_piece_moves'
# Query sent to self
# end

  describe '#forward_moves' do
    # Query sent to self
    context 'when piece is a white pawn with a first move' do
      let(:test_pawn) { Pawn.new([2, 0], 'white') }
      let(:test_first_move) { test_pawn.instance_variable_set(:@first_move, [[2, 0]]) }

      it 'returns [[1, 0]]' do
        test_array = [[1, 0]]
        test_pawn.first_move = test_first_move
        expect(test_pawn.forward_moves).to eq test_array
      end
    end

    context 'when piece is a black pawn with no first move' do
      let(:test_pawn) { Pawn.new([1, 0], 'white') }
      let(:test_first_move) { test_pawn.instance_variable_set(:@first_move, []) }

      it 'returns [[1, 0], [2, 0]]' do
        test_array = [[1, 0], [2, 0]]
        test_pawn.first_move = test_first_move
        expect(test_pawn.forward_moves).to eq test_array
      end
    end

    context 'when piece is a black pawn with a first move' do
      let(:test_pawn) { Pawn.new([5, 1], 'black') }
      let(:test_first_move) { test_pawn.instance_variable_set(:@first_move, [[5, 1]]) }

      it 'returns [[-1, 0]]' do
        test_array = [[-1, 0]]
        test_pawn.first_move = test_first_move
        expect(test_pawn.forward_moves).to eq test_array
      end
    end

    context 'when piece is a black pawn with no first move' do
      let(:test_pawn) { Pawn.new([6, 1], 'black') }
      let(:test_first_move) { test_pawn.instance_variable_set(:@first_move, []) }

      it 'returns [[-1, 0], [-2, 0]]' do
        test_array = [[-1, 0], [-2, 0]]
        test_pawn.first_move = test_first_move
        expect(test_pawn.forward_moves).to eq test_array
      end
    end
  end

# describe '#diagonal_attacks'
# Query sent to self
# end

# describe '#next_space_moves'
# Query sent to self
# end
end
