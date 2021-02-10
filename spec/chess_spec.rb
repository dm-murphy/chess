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
 
  describe "#coord_in_check" do
    # Query sent to self nested in #check_message -> #check_alert -> #in_check

    subject(:test_game) { described_class.new} 
    
    context 'when opponent Knight at [1, 2] and player King at [0, 4]' do
    
      it 'returns true' do
        opponent_moves = [[2, 4], [3, 3], [3, 1], [2, 0], [0, 0], [0, 4], [7, 5], [7, 3], [6, 4], [6, 5], [6, 3], [6, 4], [5, 5], [5, 7]]
        coord = [0, 4]
        expect(test_game.coord_in_check?(coord, opponent_moves)).to be true
      end
    end
  end
end



    # # No idea what's going on here...
    
    # let(:game_board) { double(Board) }
    # subject(:test_game) { described_class.new(game_board) }

    # context 'when white King is in check' do
    #   before do
        
    #     # game_board = Board.new
    #     grid = game_board.instance_variable_set(:@grid, 
    #       [
    #       [Square.new, Knight.new([0, 1], 'white'), Square.new, Square.new, King.new([0,4], 'white'), Square.new, Square.new, Square.new],
    #       [Square.new, Square.new, Square.new, Square.new, Square.new, Square.new, Square.new, Square.new],
    #       [Square.new, Square.new, Square.new, Square.new, Square.new, Square.new, Square.new, Square.new],
    #       [Square.new, Square.new, Square.new, Square.new, Square.new, Square.new, Square.new, Square.new],
    #       [Square.new, Square.new, Square.new, Square.new, Square.new, Square.new, Square.new, Square.new],
    #       [Square.new, Square.new, Square.new, Square.new, Square.new, Square.new, Square.new, Square.new],
    #       [Square.new, Square.new, Square.new, Square.new, Square.new, Square.new, Square.new, Square.new],
    #       [Square.new, Square.new, Square.new, Square.new, Square.new, Square.new, Square.new, Square.new]
    #       ]
    #     )

    #     game_board.show_grid
    #     # allow(game_board).to receive(:white_king.coord)
    #     white_king = game_board.instance_variable_get(:@white_king)
    #     p white_king
    #     white_king_coord = white_king.coord
    #     p white_king_coord
    #     allow(test_game).to receive(:in_check?).and_return(true)
    #   end

    #   it 'returns true' do
    #     test_game.in_check?(white_king_coord, "black")
    #     expect(test_game.check_alert).to be true
    #   end
    # end




  # end




# end
