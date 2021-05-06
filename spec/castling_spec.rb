#spec/castling_spec.rb

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

describe Castling do
  subject(:test_castling) { described_class.new(test_board, test_player_one, test_player_two) }
  let(:test_board) { Board.new }
  let(:test_player_one) { Player.new('Player 1', 'white') }
  let(:test_player_two) { Player.new('Player 2', 'black') }

# describe '#castle' do
# # Script
# end

# describe '#king_side_castle' do
# # Script
# end

# describe '#find_king_side_rook' do
# # Outgoing query
# end

# describe '#find_king_side_path' do
# # Query sent to self
# end

# describe '#path_in_check?' do
# # Query sent to self
# end

  describe '#add_king_side_move' do
    # Outgoing query
    let(:white_coordinate) { [0, 6] }
    let(:black_coordinate) { [7, 6] }
    let(:test_castle_destination) { test_castling.instance_variable_set(:@castle_destination, []) }
    let(:test_legal_moves) { [] }

    context 'when origin piece is white' do
      
      it 'sends white_array coordinate to legal_moves array and @castle_destination array' do
        expect(test_legal_moves).to receive(:push).with(white_coordinate)
        expect(test_castle_destination).to receive(:push).with(white_coordinate)
        test_piece = King.new([0, 4], 'white')
        test_castling.add_king_side_move(test_piece, test_legal_moves)
      end 
    end

    context 'when origin piece is black' do
  
      it 'sends black_array coordinate to legal_moves array and @castle_destination array' do
        expect(test_legal_moves).to receive(:push).with(black_coordinate)
        expect(test_castle_destination).to receive(:push).with(black_coordinate)
        test_piece = King.new([7, 4], 'black')
        test_castling.add_king_side_move(test_piece, test_legal_moves)
      end 
    end
  end

# describe '#queen_side_castle' do
# # Script
# end

# describe '#find_queen_side_rook' do
# # Outgoing query
# end

# describe '#find_queen_side_path' do
# # Query sent to self
# end

  describe '#add_queen_side_move' do
    # Outgoing query
    let(:white_coordinate) { [0, 2] }
    let(:black_coordinate) { [7, 2] }
    let(:test_castle_destination) { test_castling.instance_variable_set(:@castle_destination, []) }
    let(:test_legal_moves) { [] }

    context 'when origin piece is white' do

      it 'sends white_array coordinate to legal_moves array and @castle_destination array' do
        expect(test_legal_moves).to receive(:push).with(white_coordinate)
        expect(test_castle_destination).to receive(:push).with(white_coordinate)
        test_piece = King.new([0, 4], 'white')
        test_castling.add_queen_side_move(test_piece, test_legal_moves)
      end 
    end

    context 'when origin piece is black' do
  
      it 'sends black_array coordinate to legal_moves array and @castle_destination array' do
        expect(test_legal_moves).to receive(:push).with(black_coordinate)
        expect(test_castle_destination).to receive(:push).with(black_coordinate)
        test_piece = King.new([7, 4], 'black')
        test_castling.add_queen_side_move(test_piece, test_legal_moves)
      end 
    end
  end

# describe '#update_castling_rooks' do
# # Script
# end

  describe '#rook_castled?' do
    # Outgoing query
    let(:test_castle_destination) { test_castling.instance_variable_set(:@castle_destination, [[0, 6]]) }
    let(:test_destination_coord) { [0, 6] }
    it 'sends message to instance variable @castle_destination' do
      expect(test_castle_destination).to receive(:include?).with(test_destination_coord)
      test_castling.rook_castled?(test_destination_coord)
    end
  end

# describe '#find_rook_start' do
# # Query sent to self
# end

# describe '#find_rook_destination' do
# # Query sent to self
# # end
end
