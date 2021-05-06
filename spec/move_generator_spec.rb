#spec/move_generator_spec.rb

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

describe MoveGenerator do

  subject(:test_game) { described_class.new(test_board, test_player_one, test_player_two) }
  let(:test_board) { Board.new }
  let(:test_player_one) { Player.new('Player 1', 'white') }
  let(:test_player_two) { Player.new('Player 2', 'black') }

# describe '#ask_user_start' do
# # Loop script
# # Tests and comments below for methods inside #ask_move, #string_to_coord, #coords_to_grid_object, #player_piece?
# end

# describe '#ask_move' do
# # Outgoing query sent to Player class
# end

  describe '#string_to_coord' do
    # Query sent to self
    context 'when given a string of numbers' do

      it 'returns array of coordinates' do
        string = '12'
        result = [1, 2]
        expect(test_game.string_to_coord(string)).to eq result
      end
    end
  end

# describe 'no_player_moves?' do
# # Query script sent to self
# end

  describe 'all_legal_moves' do
    # Command script sent to self
    context 'when white player pieces have at least one move' do

      it 'returns array of moves' do
        test_player_king = King.new([0, 0], 'white')
        test_player_pieces = [test_player_king]
        test_king_moves = [[1, 0], [1, 1], [0, 1]]
        test_king_legal_moves = [[1, 1], [0, 1]]
        legal_array = [[[1, 1], [0, 1]]]
        allow(test_game).to receive(:find_piece_moves) { test_king_moves }
        allow(test_game).to receive(:find_piece_legal_moves) { test_king_legal_moves }
        expect(test_game.all_legal_moves(test_player_pieces)).to eq legal_array
      end
    end

    context 'when white player pieces have no legal moves' do

      it 'returns empty array' do
        test_player_king = King.new([0, 0], 'white')
        test_player_pieces = [test_player_king]
        test_king_moves = [[1, 0], [1, 1], [0, 1]]
        test_king_legal_moves = []
        legal_array = [[]]
        allow(test_game).to receive(:find_piece_moves) { test_king_moves }
        allow(test_game).to receive(:find_piece_legal_moves) { test_king_legal_moves }
        expect(test_game.all_legal_moves(test_player_pieces)).to eq legal_array
      end
    end
  end

# describe '#player_piece?' do
# Query sent to self comparing outgoing query to Player class with outgoing query to piece's class
# end

# describe '#coords_to_grid_object' do
# # Outgoing query sent to Board class
# end

# describe '#find_piece_moves' do
# # Outgoing query sent to piece's class
# end

  describe '#find_piece_legal_moves' do
    # Query sent to self
    
    context 'when all moves are legal' do
      it 'returns array with all moves' do
        moves = [[1, 3], [2, 2], [2, 0]]
        origin_piece = Knight.new([0, 1], 'white')

        full_array = [[1, 3], [2, 2], [2, 0]]
        allow(test_game).to receive(:illegal_move?).with([1, 3], origin_piece) { false }
        allow(test_game).to receive(:illegal_move?).with([2, 2], origin_piece) { false }
        allow(test_game).to receive(:illegal_move?).with([2, 0], origin_piece) { false }

        expect(test_game.find_piece_legal_moves(moves, origin_piece)).to eq full_array
      end
    end

    context 'when one move is illegal' do
      it 'returns array without the illegal move' do
        moves = [[1, 3], [2, 2], [2, 0]]
        origin_piece = Knight.new([0, 1], 'white')

        partial_array = [[2, 2], [2, 0]]
        allow(test_game).to receive(:illegal_move?).with([1, 3], origin_piece) { true }
        allow(test_game).to receive(:illegal_move?).with([2, 2], origin_piece) { false }
        allow(test_game).to receive(:illegal_move?).with([2, 0], origin_piece) { false }

        expect(test_game.find_piece_legal_moves(moves, origin_piece)).to eq partial_array
      end
    end

    context 'when all moves are illegal' do
      it 'returns empty array' do
        moves = [[1, 3], [2, 2], [2, 0]]
        origin_piece = Knight.new([0, 1], 'white')

        empty_array = []
        allow(test_game).to receive(:illegal_move?).with([1, 3], origin_piece) { true }
        allow(test_game).to receive(:illegal_move?).with([2, 2], origin_piece) { true }
        allow(test_game).to receive(:illegal_move?).with([2, 0], origin_piece) { true }

        expect(test_game.find_piece_legal_moves(moves, origin_piece)).to eq empty_array
      end
    end
  end

# describe '#illegal_move?' do
#  # Query script
#  # Tests and comments below for methods inside #occupied_by_player?, #blocked?, #move_puts_self_in_check?,
#  # #king_stays_in_check?, #illegal_pawn_move?
# end

  describe '#occupied_by_player?' do
    # Query outgoing to player class and piece or square object

    context 'when coordinate is a blank square' do

      it 'returns false' do
        test_coord = [2, 0]
        test_piece = Knight.new([0, 1], 'white')

        blank_square = Square.new
        allow(test_game).to receive(:coords_to_grid_object) { blank_square }
        expect(test_game.occupied_by_player?(test_coord, test_piece)).to be false
      end
    end

    context 'when player piece is white and coordinate is a black piece' do
  
      it 'returns false' do
        test_coord = [2, 2]
        test_piece = Knight.new([0, 1], 'white')

        black_knight = Knight.new([2, 2], 'black')
        allow(test_game).to receive(:coords_to_grid_object) { black_knight }
        expect(test_game.occupied_by_player?(test_coord, test_piece)).to be false
      end
    end

    context 'when player piece is white and coordinate is a white piece' do
  
      it 'returns true' do
        test_coord = [1, 3]
        test_piece = Knight.new([0, 1], 'white')

        other_white_knight = Knight.new([1, 3], 'white')
        allow(test_game).to receive(:coords_to_grid_object) { other_white_knight }
        expect(test_game.occupied_by_player?(test_coord, test_piece)).to be true
      end
    end

    context 'when player piece is black and coordinate is a white piece' do
    
      it 'returns false' do
        test_coord = [5, 2]
        test_piece = Knight.new([7, 1], 'black')

        white_knight = Knight.new([5, 2], 'white')
        allow(test_game).to receive(:coords_to_grid_object) { white_knight }
        expect(test_game.occupied_by_player?(test_coord, test_piece)).to be false
      end
    end

    context 'when player piece is black and coordinate is a black piece' do
    
      it 'returns true' do
        test_coord = [6, 3]
        test_piece = Knight.new([7, 1], 'black')

        other_black_knight = Knight.new([6, 3], 'black')
        allow(test_game).to receive(:coords_to_grid_object) { other_black_knight }
        expect(test_game.occupied_by_player?(test_coord, test_piece)).to be true
      end
    end
  end

  describe 'king_in_check?' do
    # Query Script sent to self

    context 'when opponent Rook is at [7, 0] with opponent King at [0, 4] and player King at [7, 4] and player Knight at [7, 1]' do

      it 'returns false' do

        piece = King.new([7, 4], 'black')
        king_coord = [7, 4]

        test_moves = [[[7, 1], [6, 0], [5, 0], [4, 0], [3, 0], [2, 0], [1, 0], [0, 0]],
                     [[0, 3], [0, 5], [1, 3], [1, 4], [1, 5]]]

        allow(test_game).to receive(:find_opponent_moves) { test_moves }
        expect(test_game.king_in_check?(piece, king_coord)).to be false
      end
    end
  end

  describe 'move_keeps_king_in_check?' do
    # Query sent to self but uses commands in Board class

    context 'when opponent Rook is at [2, 4], and player King at [7, 4] with player move of Knight from [5, 2] to [6, 4]' do

      it 'returns true' do
        test_move = [6, 4]
        test_origin_piece = Knight.new([5, 2], 'black')
        test_king_coord = [7, 4]

        expect(test_board).to receive(:move_piece_to_coords).exactly(3)
        allow(test_game).to receive(:king_in_check?) { false }
        expect(test_game.move_keeps_king_in_check?(test_move, test_origin_piece, test_king_coord)).to be false
      end
    end
  end

# describe '#piece_is_king?' do
#  # Query sent to self
# end

# describe '#find_king' do
#  # Outgoing query sent to Board
# end

  describe '#find_opponent_moves' do

    context 'when opponent Rook is at [7, 0] and opponent King at [0, 4] and player King at [7, 4] and player Knights at [7, 1] and [7, 6]' do

      it 'returns array of all opponent moves' do
        opponent = 'white'
        move = [5, 5]
        result = [[[7, 1], [6, 0], [5, 0], [4, 0], [3, 0], [2, 0], [1, 0], [0, 0]],
                  [[0, 3], [0, 5], [1, 3], [1, 4], [1, 5]]]

        test_rook = Rook.new([7, 7], 'white')
        test_king = King.new([0, 4], 'white')
        test_pieces = [test_rook, test_king]
        test_remaining_pieces = [test_rook, test_king]
        test_available_opponent_moves = [[[7, 1], [6, 0], [5, 0], [4, 0], [3, 0], [2, 0], [1, 0], [0, 0]],
        [[0, 3], [0, 5], [1, 3], [1, 4], [1, 5]]]

        allow(test_game).to receive(:find_pieces) { test_pieces }
        allow(test_game).to receive(:remove_possible_capture) { test_remaining_pieces }
        allow(test_game).to receive(:find_available_opponent_moves) { test_available_opponent_moves }
        expect(test_game.find_opponent_moves(opponent, move)).to eq result
      end
    end
  end

  describe '#find_opponent' do
    # Query sent to self

    context "when piece equals 'white'" do

      it "returns 'black'" do
        test_piece = Knight.new([0, 1], 'white')
        string = 'black'
        expect(test_game.find_opponent(test_piece)).to eq string
      end
    end

    context "when piece equals 'black'" do

      it "returns 'white'" do
        test_piece = Knight.new([7, 6], 'black')
        string = 'white'
        expect(test_game.find_opponent(test_piece)).to eq string
      end
    end 
  end

  describe '#find_pieces' do
    # Query sent to self

    subject(:find_pieces_test_game) { described_class.new(pieces_test_board, pieces_test_player_one, pieces_test_player_two) }
    let(:pieces_test_board) { Board.new }
    let(:pieces_test_player_one) { Player.new('Player 1', 'white') }
    let(:pieces_test_player_two) { Player.new('Player 2', 'black') }
    let(:opponent_knight_one) { Knight.new([7, 1], 'black') }
    let(:opponent_knight_two) { Knight.new([7, 6], 'black') }
    let(:opponent_king) { King.new([7, 4], 'black') }

    context 'when mapping through black player pieces on Board grid' do

      it 'returns array of pieces that match black player' do

        pieces_test_board.instance_variable_set(:@grid,
          [
            [Square.new, Knight.new([0, 1], 'white'), Square.new, Square.new, King.new([0, 4], 'white'), Square.new, Knight.new([0, 6], 'white'), Square.new],
            [Square.new, Square.new, Square.new, Square.new, Square.new, Square.new, Square.new, Square.new],
            [Square.new, Square.new, Square.new, Square.new, Square.new, Square.new, Square.new, Square.new],
            [Square.new, Square.new, Square.new, Square.new, Square.new, Square.new, Square.new, Square.new],
            [Square.new, Square.new, Square.new, Square.new, Square.new, Square.new, Square.new, Square.new],
            [Square.new, Square.new, Square.new, Square.new, Square.new, Square.new, Square.new, Square.new],
            [Square.new, Square.new, Square.new, Square.new, Square.new, Square.new, Square.new, Square.new],
            [Square.new, opponent_knight_one, Square.new, Square.new, opponent_king, Square.new, opponent_knight_two, Square.new]
          ]
        )

        test_player = pieces_test_player_two.pieces
        test_pieces = [opponent_knight_one, opponent_king, opponent_knight_two]
        expect(find_pieces_test_game.find_pieces(test_player)).to eq test_pieces
      end
    end
  end

  describe '#remove_possible_capture' do
    # Query sent to self

    let(:opponent_knight_one) { Knight.new([2, 1], 'black') }
    let(:opponent_knight_two) { Knight.new([3, 4], 'black') }
    let(:opponent_king) { King.new([7, 4], 'black') }

    context 'when opponent pieces includes a coordinate the current player is moving to capture' do

      it 'returns array of opponent pieces without the captured piece' do
        opponent_pieces = [opponent_knight_one, opponent_knight_two, opponent_king]
        move = [2, 1]

        remaining_pieces = [opponent_knight_two, opponent_king]
        expect(test_game.remove_possible_capture(opponent_pieces, move)).to eq remaining_pieces
      end
    end

    context 'when opponent pieces does not include a coordinate the current player is moving to' do

      it 'returns array of all opponent pieces' do
        opponent_pieces = [opponent_knight_one, opponent_knight_two, opponent_king]
        move = [1, 6]

        remaining_pieces = [opponent_knight_one, opponent_knight_two, opponent_king]
        expect(test_game.remove_possible_capture(opponent_pieces, move)).to eq remaining_pieces
      end
    end
  end

  describe '#coord_in_check?' do
    # Query sent to self
  
    context 'when opponent Knight at [1, 2] and player King at [0 , 4]' do
  
      it 'returns true' do
        opponent_moves = [[2, 4], [3, 3], [3, 1], [2, 0], [0, 0], [0, 4]]
        coord = [0, 4]
        expect(test_game.coord_in_check?(coord, opponent_moves)).to be true
      end
    end

    context 'when opponent Knight is at [7, 1] and player King at [0, 4]' do
  
      it 'returns false' do
        opponent_moves = [[5, 0], [5, 2], [6, 3]]
        coord = [0, 4]
        expect(test_game.coord_in_check?(coord, opponent_moves)).to be false
      end
    end

    context 'when opponent Rook is at [7, 0] with opponent King at [0, 4] and player King at [7, 4] and player Knight at [7, 1]' do
    
      it 'returns false' do
        opponent_moves = [[[7, 1], [6, 0], [5, 0], [4, 0], [3, 0], [2, 0], [1, 0], [0, 0]],
                          [[0, 3], [0, 5], [1, 3], [1, 4], [1, 5]]]
        coord = [7, 4]
        expect(test_game.coord_in_check?(coord, opponent_moves)).to be false
      end
    end
  end

# describe '#ask_user_destination' do
  # Query loop sent to Player class, returns user input as coordinate
# end

  describe '#update_board' do
    # Outgoing Command, test message sent

    context 'when user makes a legal move' do

      it 'updates the board' do
        expect(test_board).to receive(:change_pieces)
        start_coord = [0, 1]
        destination_coord = [2, 2]
        test_game.update_board(start_coord, destination_coord)
      end
    end
  end

  describe '#swap_player' do
    # Command sent to self

    context 'when @current_player is @player_one' do

      it 'sets @current_player to @player_two' do
        first_player = test_game.instance_variable_get(:@player_one)
        second_player = test_game.instance_variable_get(:@player_two)
        test_game.instance_variable_set(:@current_player, first_player)

        expect { test_game.swap_player }.to change { test_game.instance_variable_get(:@current_player) }.from(first_player).to(second_player)
      end
    end

    context 'when @current_player is @player_two' do

      it 'sets @current_player to @player_one' do
        first_player = test_game.instance_variable_get(:@player_one)
        second_player = test_game.instance_variable_get(:@player_two)
        test_game.instance_variable_set(:@current_player, second_player)

        expect { test_game.swap_player }.to change { test_game.instance_variable_get(:@current_player) }.from(second_player).to(first_player)
      end
    end
  end
end