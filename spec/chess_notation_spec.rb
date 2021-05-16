#spec/move_generator_spec.rb

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

describe ChessNotation do

# describe '#convert_move_to_coord' 
# # Query sent to self
# end

# describe '#convert_move_to_correct_numbers'
# # Query sent to self
# end

  describe '#letter_to_number' do
    # Query sent to self
    context 'when a letter string is passed into the method' do
      let(:test_chess_notation) { described_class.new }
      it 'returns the corresponding number string' do
        test_letter = 'd'
        test_number = '3'
        expect(test_chess_notation.letter_to_number(test_letter)).to eq test_number
      end
    end
  end

  describe '#number_to_number' do
    # Query sent to self
    context 'when a number string is passed into the method' do
      let(:test_chess_notation) { described_class.new }
      it 'returns the corresponding number string' do
        test_number = '6'
        test_result = '5'
        expect(test_chess_notation.number_to_number(test_number)).to eq test_result
      end
    end
  end

  describe '#string_to_coord' do
    # Query sent to self
    context 'when given a string of numbers' do
      let(:test_chess_notation) { described_class.new }
      it 'returns array of coordinates' do
        string = '12'
        result = [1, 2]
        expect(test_chess_notation.string_to_coord(string)).to eq result
      end
    end
  end

# describe coords_to_chess_notation
# # Query sent to self
# end

  describe '#notate' do
    # Query sent to self
    context 'when a coordinate move is passed into the method' do
      let(:test_chess_notation) { described_class.new }
      it 'returns the corresponding chess notation string' do
        test_coordinate = [3, 0]
        test_notation = 'a4'
        expect(test_chess_notation.notate(test_coordinate)).to eq test_notation
      end
    end
  end

  describe '#y_coord_to_letter' do
    # Query sent to self
    context 'when a number integer is passed into the method' do
      let(:test_chess_notation) { described_class.new }
      it 'returns the corresponding letter string' do
        test_number = 1
        test_result = 'b'
        expect(test_chess_notation.y_coord_to_letter(test_number)).to eq test_result
      end
    end
  end


  describe '#x_coord_to_number' do
    # Query sent to self
    context 'when a number integer is passed into the method' do
      let(:test_chess_notation) { described_class.new }
      it 'returns the corresponding number string' do
        test_number = 3
        test_result = '4'
        expect(test_chess_notation.x_coord_to_number(test_number)).to eq test_result
      end
    end
  end
end
