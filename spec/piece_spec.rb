#spec/piece_spec.rb

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

describe Piece do

  describe '#find_possible_moves' do
    # Outgoing command
    # Pawn class uses it's own #find_possible_moves variation, see tests in pawn_spec.rb
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

    context 'when a white bishop coordiantes are valid for 7 positions' do
      let(:test_bishop) { Bishop.new([0, 2], 'white') }
      let(:test_possible_moves) { test_bishop.instance_variable_set(:@possible_moves, []) }

      it 'sends message to @possible_moves 7 times' do
        expect(test_possible_moves).to receive(:push).exactly(7)
        test_bishop.find_possible_moves
      end
    end

    context 'when a black bishop coordinates are valid for 13 positions' do
      let(:test_bishop) { Bishop.new([4, 4], 'black') }
      let(:test_possible_moves) { test_bishop.instance_variable_set(:@possible_moves, []) }

      it 'sends message to @possible_moves 13 times' do
        expect(test_possible_moves).to receive(:push).exactly(13)
        test_bishop.find_possible_moves
      end
    end

    context 'when a white knight coordinates are valid for 3 positions' do
      let(:test_knight) { Knight.new([0, 1], 'white') }
      let(:test_possible_moves) { test_knight.instance_variable_set(:@possible_moves, []) }

      it 'sends message to @possible_moves 3 times' do
        expect(test_possible_moves).to receive(:push).exactly(3)
        test_knight.find_possible_moves
      end
    end

    context 'when a black knight coordinates are valid for 8 positions' do
      let(:test_knight) { Knight.new([4, 4], 'black') }
      let(:test_possible_moves) { test_knight.instance_variable_set(:@possible_moves, []) }

      it 'sends message to @possible_moves 8 times' do
        expect(test_possible_moves).to receive(:push).exactly(8)
        test_knight.find_possible_moves
      end
    end

    context 'when a white queen coordinates are valid for 21 positions' do
      let(:test_queen) { Queen.new([0, 3], 'white') }
      let(:test_possible_moves) { test_queen.instance_variable_set(:@possible_moves, []) }

      it 'sends message to @possible_moves 21 times' do
        expect(test_possible_moves).to receive(:push).exactly(21)
        test_queen.find_possible_moves
      end
    end

    context 'when a black queen coordinates are valid for 27 positions' do
      let(:test_queen) { Queen.new([4, 4], 'black') }
      let(:test_possible_moves) { test_queen.instance_variable_set(:@possible_moves, []) }

      it 'sends message to @possible_moves 27 times' do
        expect(test_possible_moves).to receive(:push).exactly(27)
        test_queen.find_possible_moves
      end
    end

    context 'when a white king coordinates are valid for 5 positions' do
      let(:test_king) { King.new([0, 4], 'white') }
      let(:test_possible_moves) { test_king.instance_variable_set(:@possible_moves, []) }

      it 'sends message to @possible_moves 5 times' do
        expect(test_possible_moves).to receive(:push).exactly(5)
        test_king.find_possible_moves
      end
    end

    context 'when a black king coordinates are valid for 8 positions' do
      let(:test_king) { King.new([4, 4], 'black') }
      let(:test_possible_moves) { test_king.instance_variable_set(:@possible_moves, []) }

      it 'sends message to @possible_moves 8 times' do
        expect(test_possible_moves).to receive(:push).exactly(8)
        test_king.find_possible_moves
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
