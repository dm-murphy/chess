#spec/chess_spec.rb

require './lib/game'
require './lib/player'
require './lib/board'
require './lib/square'
require './lib/knight'
require './lib/king'

describe Game do

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
 
  describe '#coord_in_check?' do
    # Query sent to self, nested in #king_in_check? -> #illegal_move? -> #find_legal_moves -> #start_turn

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
  end

  describe '#remove_possible_capture' do
    # Command sent to self, nested in #find_opponent_moves -> #king_in_check?

    subject(:test_game) { described_class.new }
    let(:opponent_knight_one) { Knight.new([2, 1], 'black') }
    let(:opponent_knight_two) { Knight.new([3, 4], 'black') }
    let(:opponent_king) { King.new([7, 6], 'black') }

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
  # Query sent to Node objects class: (Knight, King), nested in #find_opponent_moves -> #king_in_check
# end

# describe '#ask_user_destination' do
  # Query loop sent to Player class, returns user input as coordinate, nested in nested in #start_turn
# end

end

  # Test?
   
    #ask_user_start

    #coords_to_node

    #find_node_moves







    # find_legal_moves



    # find_opponent
    # find_opponent_pieces
    
    

    # ask_user_destination

   
