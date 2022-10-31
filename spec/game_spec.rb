require_relative '../lib/pieces'
require_relative '../lib/pieces_moves'
require_relative '../lib/board'
require_relative '../lib/logic'
require_relative '../lib/game'

describe Game do
  include Pieces
  include PiecesMoves
  include Logic

  subject(:game) { Game.new }
  subject(:board) { Board.new }

  describe '#initialize' do
    it 'creates a new board' do
      expect(game.board).to be_a(Board)
    end
    it 'sets the current turn to white' do
      expect(game.turn).to eq('white')
    end
    it 'sets the turn count to 0' do
      expect(game.turn_count).to eq(0)
    end
    it 'sets the history to an empty array' do
      expect(game.history).to eq([])
    end
  end
  describe '#start' do
  end
  describe '#king_on_checkmate?' do
    describe 'when the white king is on checkmate' do
      before do
        game.board.grid[0][0] = king_white
        game.board.grid[3][0] = queen_black
        game.board.grid[3][1] = queen_black
      end
      it 'returns true' do
        expect(game.king_on_checkmate?(game.board.grid, 'white')).to be true
      end
    end
    describe 'when the black king is on checkmate' do
      before do
        game.board.grid[0][0] = king_black
        game.board.grid[3][0] = queen_white
        game.board.grid[3][1] = queen_white
      end
      it 'returns true' do
        expect(game.king_on_checkmate?(game.board.grid, 'black')).to be true
      end
    end
    describe 'when the white king is not on checkmate' do
      before do
        game.board.grid[0][0] = king_white
        game.board.grid[3][0] = queen_black
        game.board.grid[3][1] = queen_black
        game.board.grid[0][1] = queen_white
      end
      it 'returns false' do
        expect(game.king_on_checkmate?(game.board.grid, 'white')).to be false
      end
    end
    describe 'when the black king is not on checkmate' do
      before do
        game.board.grid[0][0] = king_black
        game.board.grid[3][0] = queen_white
        game.board.grid[3][1] = queen_white
        game.board.grid[0][1] = queen_black
      end
      it 'returns false' do
        expect(game.king_on_checkmate?(game.board.grid, 'black')).to be false
      end
    end
  end
  describe '#ask_for_destiny' do
    describe 'when the user enters a valid destiny' do
      before do
        allow(game).to receive(:getting_user_input).and_return([0, 1])
      end
      it 'returns the destiny' do
        expect(game.ask_for_destiny([[0, 1]])).to eq([0, 1])
      end
    end
    describe 'when the user enters an invalid destiny' do
      before do
        allow(game).to receive(:getting_user_input).and_return([0, 1], [0, 2])
      end
      it 'returns the destiny' do
        expect(game.ask_for_destiny([[0, 1]])).to eq([0, 1])
      end
    end
  end
  describe '#getting_user_input' do
    describe 'when the user inputs a valid position' do
      it 'returns the position as an array' do
        allow(game).to receive(:gets).and_return('A1')
        expect(game.getting_user_input).to eq([0, 0])
      end
    end
    describe 'when the user inputs an invalid position' do
      it 'asks the user to input a valid position' do
        allow(game).to receive(:gets).and_return('A9', 'A1')
        expect(game.getting_user_input).to eq([0, 0])
      end
    end
  end
  describe '#next_turn' do
    describe 'when the current turn is white' do
      it 'changes the current turn to black' do
        game.next_turn
        expect(game.turn).to eq('black')
      end
    end
    describe 'when the current turn is black' do
      before { game.next_turn }
      it 'changes the current turn to white' do
        game.next_turn
        expect(game.turn).to eq('white')
      end
    end
  end
  describe '#create_board' do
    describe 'when no parameters are passed' do
      let(:new_board) { Array.new(8) { Array.new(8, ' ') } }
      before do
        new_board[0] = [rook_black, knight_black, bishop_black, queen_black,
                        king_black, bishop_black, knight_black, rook_black]
        new_board[1] = [pawn_black, pawn_black, pawn_black, pawn_black,
                        pawn_black, pawn_black, pawn_black, pawn_black]
        new_board[2] = [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ']
        new_board[3] = [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ']
        new_board[4] = [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ']
        new_board[5] = [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ']
        new_board[6] = [pawn_white, pawn_white, pawn_white, pawn_white,
                        pawn_white, pawn_white, pawn_white, pawn_white]
        new_board[7] = [rook_white, knight_white, bishop_white, queen_white,
                        king_white, bishop_white, knight_white, rook_white]
      end
      it 'creates a new board' do
        game.create_board
        expect(game.board.grid).to eq(new_board)
      end
    end
  end
  describe '#check_move' do
    describe 'when the move is valid' do
      before do
        game.board.grid[0][0] = king_white
        game.board.grid[0][1] = queen_black
      end
      it 'returns true' do
        expect(game.check_move([0, 0], [0, 1])).to be true
      end
    end
    describe 'when the move is invalid' do
      describe 'but inside the board' do
        before do
          game.board.grid[0][0] = king_white
          game.board.grid[0][1] = queen_black
        end
        it 'returns false' do
          expect(game.check_move([0, 0], [0, 2])).to be false
        end
      end
      describe 'and outside the board' do
        before do
          game.board.grid[0][0] = king_white
          game.board.grid[0][1] = queen_black
        end
        it 'returns false' do
          expect(game.check_move([0, 0], [0, 8])).to be false
        end
      end
      describe 'and the king is on check' do
        before do
          game.board.grid[0][0] = king_white
          game.board.grid[0][1] = queen_black
          game.board.grid[1][0] = queen_black
        end
        it 'returns false' do
          expect(game.check_move([0, 0], [0, 1])).to be false
        end
      end
    end
  end
  describe '#do_move' do
    describe 'when the move is valid' do
      before do
        game.board.grid[0][0] = king_white
        game.board.grid[0][1] = queen_black
      end
      it 'moves the piece' do
        game.do_move([0, 0], [0, 1])
        expect(game.board.grid[0][1]).to eq(king_white)
        expect(game.board.grid[0][0]).to eq(' ')
      end
    end
    describe 'when the move is invalid' do
      before do
        game.board.grid[0][0] = king_white
        game.board.grid[0][1] = queen_black
      end
      it 'does not move the piece' do
        game.do_move([0, 0], [0, 2])
        expect(game.board.grid[0][0]).to eq(king_white)
        expect(game.board.grid[0][1]).to eq(queen_black)
      end
    end
  end
end
