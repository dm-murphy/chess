#spec/move_generator_spec.rb

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

describe ChessNotation do

# describe '#convert_move_to_coord' 
# # Query sent to self
# end

# describe '#convert_move_to_correct_numbers'
# # Query sent to self
# end

# describe '#letter_to_number'
# # Query sent to self
# end

# describe '#number_to_number'
# # Query sent to self
# end

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

# describe notate
# # Query sent to self
# end

# describe y_coord_to_letter
# # Query sent to self
# end

# describe x_coord_to_number
# # Query sent to self
# end
end
