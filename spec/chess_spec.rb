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
 
  describe '#coord_in_check' do
    # Query sent to self nested in #check_message -> #check_alert -> #in_check

    # The opponent moves are showing all opponent piece moves

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

  # describe '#self_check?' do
  #   # Query sent to self nested in #valid_move -> #check_legal -> #find_moves

  #   let(:test_white_king) { instance_double(King) }
  #   let(:test_black_king) { instance_double(King) }
  #   let(:test_board) { instance_double(Board, white_king: test_white_king, black_king: test_black_king) }
  #   subject(:test_game) { described_class.new(test_board) }

  #   context 'when White King attempts a move that would put into check' do
    
  #     it 'returns true' do

  #       test_game.instance_variable_set(:@board, test_board)
  #       node = test_board.instance_variable_get(:@white_king)
  #       move = [1, 5]
  #       allow(test_game).to receive(:in_check?).and_return(true)
  #       # allow(test_game).to receive(:in_check?).and_return(false)
  #       # allow(test_game).to receive(:check_alert).and_return(false)
        
  #       expect(test_game.self_check?(move, node)).to be true

      
      
  #     end
    
  #   end


  # end

  # describe '#self_check?' do
  #   # Query sent to self nested in #valid_move -> #check_legal -> #find_moves

  #   subject(:test_game) { described_class.new }

  #   context 'when White King attempts a move that would put into check' do

  #     before do
  #       @board = Board.new
  #       @white_king = @board.white_king
  #     end

  #     it 'returns true' do
  #       node = @white_king
  #       move = [1, 5]
  #       # allow(test_game).to receive(:in_check?).and_return(true)
  #       expect(test_game.self_check?(move, node)).to be true
  #     end
  #   end
  # end

  # describe '#self_check?' do
  #   # Query sent to self nested in #valid_move -> #check_legal -> #find_moves

  #   let(:test_board) { instance_double(Board) }
  #   subject(:test_game) { described_class.new(test_board) }

  #   context 'when White King attempts a move that would put into check' do

  #     it 'returns true' do
  #       # node = double(:node, white_king?: true)
  #       move = [1, 5]
  #       # allow(test_game).to receive(:in_check?).and_return(true)
  #       expect(test_game.self_check?(move, node)).to be true
  #     end
  #   end
  # end




end

