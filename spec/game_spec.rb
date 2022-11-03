require_relative '../lib/pieces'
require_relative '../lib/pieces_moves'
require_relative '../lib/board'
require_relative '../lib/logic'
require_relative '../lib/game'
require_relative '../lib/player_input'

describe Game do
  include Pieces
  include PiecesMoves
  include Logic
  include PlayerInput

  subject(:game) { Game.new }
  subject(:board) { Board.new }

  before do
    allow(game).to receive(:gets).and_return('Q')
  end

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
      expect(game.board.history).to eq([])
    end
  end
  describe '#start' do
    describe 'when there is a possible En Passant' do
      let(:game) { Game.new }
      before do
        game.board.setup_board
        game.do_move([6, 3], [4, 3])
        game.do_move([1, 4], [3, 4])
        game.do_move([4, 3], [3, 3])
        game.do_move([1, 2], [3, 2])
      end
      it 'returns the possible moves' do
        expect(piece_moves(game.board.grid, [3, 3], game.board.history.last)).to eql([[2, 3], [2, 2]])
      end
    end
    describe 'when an en passant is done' do
      let(:game) { Game.new }
      before do
        game.board.setup_board
        game.do_move([6, 3], [4, 3])
        game.do_move([1, 2], [3, 2])
        game.do_move([4, 3], [3, 3])
        game.do_move([1, 4], [3, 4])
        game.do_move([3, 3], [2, 4])
      end
      it 'deletes the pawn that was captured' do
        expect(game.board.grid[3][4]).to eql(' ')
      end
      it 'moves the pawn to the correct position' do
        expect(game.board.grid[2][4]).to eql(pawn_white)
      end
      it 'delete the pawn from last move' do
        expect(game.board.grid[3][3]).to eql(' ')
      end
    end
    describe 'when a castling is done' do
      let(:game) { Game.new }
      before do
        game.board.setup_board
        game.do_move([6, 1], [4, 1]) # white pawn
        game.do_move([1, 7], [3, 7]) # black pawn
        game.do_move([4, 1], [3, 1]) # white pawn (preparing for en passant)
        game.do_move([3, 7], [4, 7]) # black pawn (preparing for en passant)
        game.do_move([7, 6], [5, 7]) # white knight
        game.do_move([1, 2], [3, 2]) # black pawn (prepared for en passant)
        game.do_move([3, 1], [2, 2]) # white pawn (en passant)
        game.do_move([0, 1], [2, 0]) # black knight
        game.do_move([6, 6], [4, 6]) # white pawn (prepared for en passant)
        game.do_move([4, 7], [5, 6]) # black pawn (en passant)
        game.do_move([7, 5], [6, 6]) # white bishop
        game.do_move([1, 1], [2, 1]) # black pawn
        game.do_move([7, 4], [7, 6]) # white king (castling)
      end
      it 'moves the king to the correct position' do
        expect(game.board.grid[7][6]).to eql(king_white)
      end
      it 'moves the rook to the correct position' do
        expect(game.board.grid[7][5]).to eql(rook_white)
      end
      it 'deletes the king from the previous position' do
        expect(game.board.grid[7][4]).to eql(' ')
      end
      it 'deletes the rook from the previous position' do
        expect(game.board.grid[7][7]).to eql(' ')
      end
    end
    describe 'when promotion is done' do
      let(:game) { Game.new }
      before do
        game.board.setup_board
        game.do_move([6, 1], [4, 1]) # white pawn
        game.do_move([1, 7], [3, 7]) # black pawn
        game.do_move([4, 1], [3, 1]) # white pawn (preparing for en passant)
        game.do_move([3, 7], [4, 7]) # black pawn (preparing for en passant)
        game.do_move([7, 6], [5, 7]) # white knight
        game.do_move([1, 2], [3, 2]) # black pawn (prepared for en passant)
        game.do_move([3, 1], [2, 2]) # white pawn (en passant)
        game.do_move([0, 1], [2, 0]) # black knight
        game.do_move([6, 6], [4, 6]) # white pawn (prepared for en passant)
        game.do_move([4, 7], [5, 6]) # black pawn (en passant)
        game.do_move([7, 5], [6, 6]) # white bishop
        game.do_move([1, 1], [2, 1]) # black pawn
        game.do_move([7, 4], [7, 6]) # white king (castling)
        game.do_move([0, 2], [1, 1]) # black bishop
        game.do_move([2, 2], [1, 2]) # white pawn
        game.do_move([1, 3], [3, 3]) # black pawn
        game.do_move([1, 2], [0, 2]) # white pawn (promotion)
        allow(game).to receive(:gets).and_return('Q')
        game.check_for_promotion
      end
      it 'promotes the pawn to a queen' do
        expect(game.board.grid[0][2]).to eql(queen_white)
      end
    end
    describe 'when a check is done' do
      let(:game) { Game.new }
      before do
        game.board.setup_board
        game.do_move([6, 1], [4, 1]) # white pawn
        game.do_move([1, 7], [3, 7]) # black pawn
        game.do_move([4, 1], [3, 1]) # white pawn (preparing for en passant)
        game.do_move([3, 7], [4, 7]) # black pawn (preparing for en passant)
        game.do_move([7, 6], [5, 7]) # white knight
        game.do_move([1, 2], [3, 2]) # black pawn (prepared for en passant)
        game.do_move([3, 1], [2, 2]) # white pawn (en passant)
        game.do_move([0, 1], [2, 0]) # black knight
        game.do_move([6, 6], [4, 6]) # white pawn (prepared for en passant)
        game.do_move([4, 7], [5, 6]) # black pawn (en passant)
        game.do_move([7, 5], [6, 6]) # white bishop
        game.do_move([1, 1], [2, 1]) # black pawn
        game.do_move([7, 4], [7, 6]) # white king (castling)
        game.do_move([0, 2], [1, 1]) # black bishop
        game.do_move([2, 2], [1, 2]) # white pawn
        game.do_move([1, 3], [3, 3]) # black pawn
        game.do_move([1, 2], [0, 2]) # white pawn (promotion)
        game.check_for_promotion
        game.do_move([1, 1], [2, 2]) # black bishop
        game.do_move([6, 4], [4, 4]) # white pawn
        game.do_move([1, 6], [3, 6]) # black pawn
        game.do_move([2, 0], [3, 2]) # white knight
        game.do_move([0, 0], [0, 1]) # black rook
        game.do_move([3, 2], [2, 4]) # white knight
        game.do_move([0, 1], [1, 1]) # black rook
        game.do_move([2, 4], [4, 3]) # white knight
        game.do_move([5, 7], [3, 6]) # black knight
        game.do_move([4, 3], [6, 4]) # white knight
      end
      it 'checks the king' do
        expect(game.check?(game.board.grid, 'white')).to eql(true)
      end
    end
    describe 'COMPLETE ROUND' do
      let(:game) { Game.new }
      before do
        game.board.setup_board
        game.do_move([6, 1], [4, 1]) # white pawn
        game.do_move([1, 7], [3, 7]) # black pawn
        game.do_move([4, 1], [3, 1]) # white pawn (preparing for en passant)
        game.do_move([3, 7], [4, 7]) # black pawn (preparing for en passant)
        game.do_move([7, 6], [5, 7]) # white knight
        game.do_move([1, 2], [3, 2]) # black pawn (prepared for en passant)
        game.do_move([3, 1], [2, 2]) # white pawn (en passant)
        game.do_move([0, 1], [2, 0]) # black knight
        game.do_move([6, 6], [4, 6]) # white pawn (prepared for en passant)
        game.do_move([4, 7], [5, 6]) # black pawn (en passant)
        game.do_move([7, 5], [6, 6]) # white bishop
        game.do_move([1, 1], [2, 1]) # black pawn
        game.do_move([7, 4], [7, 6]) # white king (castling)
        game.do_move([0, 2], [1, 1]) # black bishop
        game.do_move([2, 2], [1, 2]) # white pawn
        game.do_move([1, 3], [3, 3]) # black pawn
        game.do_move([1, 2], [0, 2]) # white pawn (promotion)
        game.do_move([1, 1], [2, 2]) # black bishop
        game.do_move([6, 4], [4, 4]) # white pawn
        game.do_move([1, 6], [3, 6]) # black pawn
        game.do_move([2, 0], [3, 2]) # white knight
        game.do_move([0, 0], [0, 1]) # black rook
      end
      it 'checksmates the king' do
        game.do_move([3, 2], [2, 4]) # white knight
        game.do_move([0, 1], [1, 1]) # black rook
        game.do_move([2, 4], [4, 3]) # white knight
        game.do_move([5, 7], [3, 6]) # black knight
        game.do_move([4, 3], [6, 4]) # white knight
        game.do_move([7, 6], [7, 7]) # black king
        game.do_move([5, 6], [6, 5]) # white pawn
        game.do_move([7, 5], [7, 4]) # black bishop
        game.do_move([3, 6], [2, 4]) # white knight
        game.do_move([6, 5], [7, 5]) # black pawn (promotion)
        game.do_move([7, 4], [7, 5]) # white rook
        game.do_move([0, 6], [2, 5]) # black knight
        game.do_move([2, 4], [0, 3]) # white knight
        game.do_move([6, 4], [5, 2]) # black knight
        game.do_move([0, 3], [2, 4]) # white knight (check mate)
        expect(game.checkmate?(game.board.grid, 'black')).to eql(true)
      end
    end
  end
  describe '#checkmate?' do
    describe 'when the white king is on checkmate' do
      before do
        game.board.grid[0][0] = king_white
        game.board.grid[3][0] = queen_black
        game.board.grid[3][1] = queen_black
      end
      it 'returns true' do
        expect(game.checkmate?(game.board.grid, 'white')).to be true
      end
    end
    describe 'when the black king is on checkmate' do
      before do
        game.board.grid[0][0] = king_black
        game.board.grid[3][0] = queen_white
        game.board.grid[3][1] = queen_white
      end
      it 'returns true' do
        expect(game.checkmate?(game.board.grid, 'black')).to be true
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
        expect(game.checkmate?(game.board.grid, 'white')).to be false
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
        expect(game.checkmate?(game.board.grid, 'black')).to be false
      end
    end
  end
  describe '#ask_for_destiny' do
    describe 'when the user enters a valid destiny' do
      before do
        allow(game).to receive(:getting_user_chose).and_return([0, 1])
      end
      it 'returns the destiny' do
        expect(game.ask_for_destiny([[0, 1]])).to eq([0, 1])
      end
    end
    describe 'when the user enters an invalid destiny' do
      before do
        allow(game).to receive(:getting_user_chose).and_return([0, 1], [0, 2])
      end
      it 'returns the destiny' do
        expect(game.ask_for_destiny([[0, 1]])).to eq([0, 1])
      end
    end
  end
  describe '#getting_user_chose' do
    describe 'when the user inputs a valid position' do
      it 'returns the position as an array' do
        allow(game).to receive(:gets).and_return('A1')
        expect(game.getting_user_chose).to eq([7, 0])
      end
    end
    describe 'when the user inputs an invalid position' do
      it 'asks the user to input a valid position' do
        allow(game).to receive(:gets).and_return('A9', 'A1')
        expect(game.getting_user_chose).to eq([7, 0])
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
  describe '#board.setup_board' do
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
        game.board.setup_board
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
        game.do_move([0, 1], [0, 5]) if game.check_move([0, 1], [0, 5])
        expect(game.board.grid[0][0]).to eq(king_white)
        expect(game.board.grid[0][1]).to eq(queen_black)
      end
    end
  end
  describe '#check_for_promotion' do
    describe 'when the white pawn' do
      describe 'reaches the last row' do
        before do
          game.board.grid[0][0] = pawn_white
          allow(game).to receive(:gets).and_return('Q')
        end
        it 'promotes the pawn' do
          game.next_turn
          game.check_for_promotion
          expect(game.board.grid[0][0]).to eq(queen_white)
        end
      end
      describe 'does not reach the last row' do
        before do
          game.board.grid[1][0] = pawn_white
          allow(game).to receive(:gets).and_return('Q')
        end
        it 'does not promote the pawn' do
          game.check_for_promotion
          expect(game.board.grid[1][0]).to eq(pawn_white)
        end
      end
    end
    describe 'when the black pawn' do
      describe 'reaches the last row' do
        before do
          game.board.grid[7][0] = pawn_black
          allow(game).to receive(:gets).and_return('Q')
        end
        it 'promotes the pawn' do
          game.check_for_promotion
          expect(game.board.grid[7][0]).to eq(queen_black)
        end
      end
      describe 'does not reach the last row' do
        before do
          game.board.grid[6][0] = pawn_black
          allow(game).to receive(:gets).and_return('Q')
        end
        it 'does not promote the pawn' do
          game.check_for_promotion
          expect(game.board.grid[6][0]).to eq(pawn_black)
        end
      end
    end
  end
end
