#spec/chess_spec.rb

require './lib/game'
require './lib/player'
require './lib/board'
require './lib/square'
require './lib/knight'
require './lib/king'
require './lib/rook'

describe Game do

# describe 'game_over?' do
# # Script sent to self
# # Tests and comments below for methods inside #checkmate?, #draw?
# end

# describe 'checkmate?' do
# # Script sent to self, nested in #game_over?
# # Tests and comments below for methods inside #all_legal_moves, #no_player_moves?, #king_in_check?
# end

# describe 'all_legal_moves' do
# # Query script sent to self, nested in #checkmate?
# end

# describe 'no_player_moves?' do
# # Query sent to self, nested in #all_legal_moves -> #checkmate?
# end

# describe '#start_turn' do
# # Loop script
# # Tests and comments below for methods inside #display_user, #ask_user_start, #find_piece_moves, #find_piece_legal_moves, #ask_user_destination, #update_board, #game_over?, #swap_player
# end

# describe '#display_user' do
# # Outgoing query sent to Board class and puts message, nested in #start_turn
# end

# describe '#ask_user_start' do
# # Loop script, nested in #start_turn
# # Tests and comments below for methods inside #string_to_coord, #coords_to_grid_object, #player_piece?
# end

  describe '#string_to_coord' do
    # Query sent to self, found in #ask_user_start and #ask_user_destination
    subject(:test_game) { described_class.new }
  
    context 'when given a string of numbers' do
  
      it 'returns array of coordinates' do
        string = '12'
        result = [1, 2]
        expect(test_game.string_to_coord(string)).to eq result
      end
    end
  end

# describe '#player_piece?' do
# # Compares outgoing query to Player class and outgoing query to piece object's class
# end

# describe '#coords_to_grid_object' do
# # Outgoing query sent to Board class, found in #check_piece, #start_turn and #occupied_by_player?
# end

# describe '#find_piece_moves' do
# # Outgoing query sent to class of piece object, nested in #start_turn
# end

  describe '#find_piece_legal_moves' do
    # Query sent to self, nested in #start_turn
    subject(:test_game) { described_class.new }

    context 'when all moves are legal' do
      it 'returns array with all moves' do
        moves = [[1, 3], [2, 2], [2, 0]]

        full_array = [[1, 3], [2, 2], [2, 0]]
        allow(test_game).to receive(:illegal_move?).with([1, 3]) { false }
        allow(test_game).to receive(:illegal_move?).with([2, 2]) { false }
        allow(test_game).to receive(:illegal_move?).with([2, 0]) { false }

        expect(test_game.find_piece_legal_moves(moves)).to eq full_array
      end
    end

    context 'when one move is illegal' do
      it 'returns array without the illegal move' do
        moves = [[1, 3], [2, 2], [2, 0]]

        partial_array = [[2, 2], [2, 0]]
        allow(test_game).to receive(:illegal_move?).with([1, 3]) { true }
        allow(test_game).to receive(:illegal_move?).with([2, 2]) { false }
        allow(test_game).to receive(:illegal_move?).with([2, 0]) { false }

        expect(test_game.find_piece_legal_moves(moves)).to eq partial_array
      end
    end

    context 'when all moves are illegal' do
      it 'returns empty array' do
        moves = [[1, 3], [2, 2], [2, 0]]

        empty_array = []
        allow(test_game).to receive(:illegal_move?).with([1, 3]) { true }
        allow(test_game).to receive(:illegal_move?).with([2, 2]) { true }
        allow(test_game).to receive(:illegal_move?).with([2, 0]) { true }

        expect(test_game.find_piece_legal_moves(moves)).to eq empty_array
      end
    end
  end

# describe '#illegal_move?' do
#  # Query script, nested in #find__piece_legal_moves -> #start_turn
#  # Tests and comments below for methods inside #occupied_by_player?, #piece_is_king? and #king_in_check?
# end

  describe '#occupied_by_player?' do
    # Query outoing to player class and piece or square object, nested in #illegal_move? -> #find_piece_legal_moves -> #start_turn
    subject(:test_game) { described_class.new }

    context 'when coordinate is a blank square' do

      it 'returns false' do
        test_coord = [2, 0]
        test_game.instance_variable_set(:@current_player, Player.new('Player 1', 'white'))

        blank_square = Square.new
        allow(test_game).to receive(:coords_to_grid_object) { blank_square }
        expect(test_game.occupied_by_player?(test_coord)).to be false
      end
    end

    context 'when player piece is white and coordinate is a black piece' do
  
      it 'returns false' do
        test_coord = [2, 2]
        test_game.instance_variable_set(:@current_player, Player.new('Player 1', 'white'))

        black_knight = Knight.new([2, 2], 'black')
        allow(test_game).to receive(:coords_to_grid_object) { black_knight }
        expect(test_game.occupied_by_player?(test_coord)).to be false
      end
    end

    context 'when player piece is white and coordinate is a white piece' do
  
      it 'returns true' do
        test_coord = [1, 3]
        test_game.instance_variable_set(:@current_player, Player.new('Player 1', 'white'))

        other_white_knight = Knight.new([1, 3], 'white')
        allow(test_game).to receive(:coords_to_grid_object) { other_white_knight }
        expect(test_game.occupied_by_player?(test_coord)).to be true
      end
    end

    context 'when player piece is black and coordinate is a white piece' do
    
      it 'returns false' do
        test_coord = [5, 2]
        test_game.instance_variable_set(:@current_player, Player.new('Player 2', 'black'))

        white_knight = Knight.new([5, 2], 'white')
        allow(test_game).to receive(:coords_to_grid_object) { white_knight }
        expect(test_game.occupied_by_player?(test_coord)).to be false
      end
    end

    context 'when player piece is black and coordinate is a black piece' do
    
      it 'returns true' do
        test_coord = [6, 3]
        test_game.instance_variable_set(:@current_player, Player.new('Player 2', 'black'))

        other_black_knight = Knight.new([6, 3], 'black')
        allow(test_game).to receive(:coords_to_grid_object) { other_black_knight }
        expect(test_game.occupied_by_player?(test_coord)).to be true
      end
    end
  end

  describe 'king_in_check?' do
    # Script, nested in #illegal_move? -> find_piece_legal_moves -> #start_turn

    subject(:test_game) { described_class.new }

    context 'when opponent Rook is at [7, 0] and player King at [7, 4] and player Knight at [7, 1] and player King at [0, 4]' do

      it 'returns false' do

        move = [5, 5]
        king_coord = [7, 4]

        test_moves = [[[6, 0], [5, 0], [4, 0], [3, 0], [2, 0], [1, 0], [0, 0]],
                     [[0, 3], [0, 5], [1, 3], [1, 4], [1, 5]]]

        allow(test_game).to receive(:find_opponent_moves) { test_moves }
        expect(test_game.king_in_check?(move, king_coord)).to be false
      end
    end
  end

# describe '#piece_is_king?' do
#  # Query sent to self, nested in #king_in_check?
# end

# describe '#find_king' do
#  # Outgoing query sent to Board, called from #piece_is_king? and #checkmate?
# end

# describe '#find_opponent_moves' do
#  # Script, nested in #king_in_check?
#  # Tests below for methods inside #find_opponent, #find_pieces, #remove_possible_capture
#  # For #find_possible_moves test the outgoing query #possible_moves in each piece class
# end

  describe '#find_opponent' do
    # Query sent to self, nested in #find_opponent_moves -> #king_in_check
    
    subject(:test_game) { described_class.new }

    context "when @current_player pieces equals 'white'" do
    
      it "returns 'black'" do
        test_game.instance_variable_set(:@current_player, Player.new('Player 1', 'white'))

        string = 'black'
        expect(test_game.find_opponent).to eq string
      end
    end
  
    context "when @current_player pieces equals 'black'" do
    
      it "returns 'white'" do
        test_game.instance_variable_set(:@current_player, Player.new('Player 2', 'black'))

        string = 'white'
        expect(test_game.find_opponent).to eq string      
      end
    end 
  end

  describe '#find_pieces' do
    # Query sent to self, nested in #find_opponent_moves -> #king_in_check?

    let(:test_board) { Board.new }
    subject(:test_game) { described_class.new(test_board) }
    let(:opponent_knight_one) { Knight.new([7, 1], 'black') }
    let(:opponent_knight_two) { Knight.new([7, 6], 'black') }
    let(:opponent_king) { King.new([7, 4], 'black') }


    context 'when mapping through Board object grid' do

      it 'returns array of pieces that match opponent type' do

        test_board.instance_variable_set(:@grid, 
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

        opponent = 'black'

        opponent_pieces = [opponent_knight_one, opponent_king, opponent_knight_two]
        expect(test_game.find_pieces(opponent)).to eq opponent_pieces
      end
    end
  end

  describe '#remove_possible_capture' do
    # Query sent to self, nested in #find_opponent_moves -> #king_in_check?

    subject(:test_game) { described_class.new }
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

# describe '#find_possible_moves' do
  # Query sent to piece objects class: (Knight, King), nested in #find_opponent_moves -> #king_in_check
# end

  describe '#coord_in_check?' do
    # Query sent to self, nested in #king_in_check? -> #illegal_move? -> #find_piece_legal_moves -> #start_turn

    # Opponent_moves show all opponent piece moves

    subject(:test_game) { described_class.new } 
  
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
        # opponent_moves = [[6, 0], [5, 0], [4, 0], [3, 0], [2, 0], [1, 0], [0, 0]]
        opponent_moves = [[[6, 0], [5, 0], [4, 0], [3, 0], [2, 0], [1, 0], [0, 0]],
                          [[0, 3], [0, 5], [1, 3], [1, 4], [1, 5]]]
        coord = [7, 4]
        expect(test_game.coord_in_check?(coord, opponent_moves)).to be false
      end
    end
  end

# describe '#ask_user_destination' do
  # Query loop sent to Player class, returns user input as coordinate, nested in nested in #start_turn
# end

  describe '#update_board' do
    # Outgoing Command, test message sent

    let(:board) { instance_double(Board) }
    subject(:test_game) { described_class.new(board) }

    context 'when user makes a legal move' do

      it 'updates the board' do
        expect(board).to receive(:change_pieces)
        start_coord = [0, 1]
        destination_coord = [2, 2]
        test_game.update_board(start_coord, destination_coord)
      end
    end
  end

  describe '#swap_player' do
    # Command sent to self, but #swap_player is part of public script in #start so test

    subject(:test_game) { described_class.new }

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
