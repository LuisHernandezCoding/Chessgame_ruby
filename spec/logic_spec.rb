require_relative '../lib/logic'
require_relative '../lib/pieces_moves'
require_relative '../lib/pieces'

describe Logic do
  include Pieces
  include PiecesMoves
  include Logic

  let(:board) { Array.new(8) { Array.new(8, ' ') } }

  describe '#check?' do
    describe 'when its a white king' do
      describe 'and the king is not in check' do
        before do
          board[4][4] = king_white
        end
        it 'returns false' do
          expect(check?(board, 'white')).to eql(false)
        end
      end
      describe 'and the king is in check' do
        before do
          board[4][4] = king_white
          board[5][5] = pawn_black
        end
        it 'returns true' do
          expect(check?(board, 'white')).to eql(true)
        end
      end
      describe 'and the king is in check by a knight' do
        before do
          board[4][4] = king_white
          board[6][5] = knight_black
        end
        it 'returns true' do
          expect(check?(board, 'white')).to eql(true)
        end
      end
      describe 'and the king is in check by a bishop' do
        before do
          board[4][4] = king_white
          board[6][6] = bishop_black
        end
        it 'returns true' do
          expect(check?(board, 'white')).to eql(true)
        end
      end
      describe 'and the king is in check by a rook' do
        before do
          board[4][4] = king_white
          board[6][4] = rook_black
        end
        it 'returns true' do
          expect(check?(board, 'white')).to eql(true)
        end
      end
      describe 'and the king is in check by a queen' do
        before do
          board[4][4] = king_white
          board[6][6] = queen_black
        end
        it 'returns true' do
          expect(check?(board, 'white')).to eql(true)
        end
      end
    end
    describe 'when its a black king' do
      describe 'and the king is not in check' do
        before do
          board[4][4] = king_black
        end
        it 'returns false' do
          expect(check?(board, 'black')).to eql(false)
        end
      end
      describe 'and the king is in check' do
        before do
          board[4][4] = king_black
          board[3][3] = pawn_white
        end
        it 'returns true' do
          expect(check?(board, 'black')).to eql(true)
        end
      end
      describe 'and the king is in check by a knight' do
        before do
          board[4][4] = king_black
          board[2][3] = knight_white
        end
        it 'returns true' do
          expect(check?(board, 'black')).to eql(true)
        end
      end
      describe 'and the king is in check by a bishop' do
        before do
          board[4][4] = king_black
          board[2][2] = bishop_white
        end
        it 'returns true' do
          expect(check?(board, 'black')).to eql(true)
        end
      end
      describe 'and the king is in check by a rook' do
        before do
          board[4][4] = king_black
          board[2][4] = rook_white
        end
        it 'returns true' do
          expect(check?(board, 'black')).to eql(true)
        end
      end
    end
  end
  describe '#checkmate?' do
    describe 'when its a white king' do
      describe 'and the king is not in checkmate' do
        before do
          board[4][4] = king_white
          board[5][5] = pawn_black
        end
        it 'returns false' do
          expect(checkmate?(board, 'white')).to eql(false)
        end
      end
      describe 'and the king is in checkmate' do
        before do
          board[4][4] = king_white
          board[0][4] = queen_black
          board[4][0] = rook_black
          board[0][0] = bishop_black
          board[6][6] = pawn_black
          board[0][3] = rook_black
          board[1][6] = knight_black
        end
        it 'returns true' do
          expect(checkmate?(board, 'white')).to eql(true)
        end
      end
      describe 'and the king is in checkmate by knights' do
        before do
          board[4][4] = king_white
          board[6][2] = knight_black
          board[6][3] = knight_black
          board[6][5] = knight_black
          board[6][6] = knight_black
          board[4][1] = knight_black
          board[4][7] = knight_black
          board[1][5] = knight_black
        end
        it 'returns true' do
          expect(checkmate?(board, 'white')).to eql(true)
        end
      end
      describe 'and the king is in checkmate by bishops' do
        before do
          board[4][4] = king_white
          board[2][0] = bishop_black
          board[2][1] = bishop_black
          board[2][2] = bishop_black
          board[2][3] = bishop_black
          board[2][4] = bishop_black
        end
        it 'returns true' do
          expect(checkmate?(board, 'white')).to eql(true)
        end
      end
      describe 'and the king is in checkmate by rooks' do
        before do
          board[4][4] = king_white
          board[0][3] = rook_black
          board[0][4] = rook_black
          board[0][5] = rook_black
        end
        it 'returns true' do
          expect(checkmate?(board, 'white')).to eql(true)
        end
      end
      describe 'and the king is in checkmate by queens' do
        before do
          board[4][4] = king_white
          board[0][3] = queen_black
          board[0][4] = queen_black
          board[0][5] = queen_black
        end
        it 'returns true' do
          expect(checkmate?(board, 'white')).to eql(true)
        end
      end
      describe 'and the king is in checkmate by pawns' do
        before do
          board[4][4] = king_white
          board[6][4] = pawn_black
          board[6][5] = pawn_black
          board[5][2] = pawn_black
          board[5][6] = pawn_black
          board[4][2] = pawn_black
          board[4][6] = pawn_black
          board[4][3] = pawn_black
          board[4][5] = pawn_black
        end
        it 'returns true' do
          expect(checkmate?(board, 'white')).to eql(true)
        end
      end
      describe 'and the king is in check by pawns but have 1 exit' do
        before do
          board[4][4] = king_white
          board[6][4] = pawn_black
          board[6][5] = pawn_black
          board[5][2] = pawn_black
          board[5][6] = pawn_black
          board[4][2] = pawn_black
          board[4][6] = pawn_black
        end
        it 'returns false' do
          expect(checkmate?(board, 'white')).to eql(false)
        end
      end
      describe 'and the king is in check by pawns but have 2 exits' do
        before do
          board[4][4] = king_white
          board[6][4] = pawn_black
          board[6][5] = pawn_black
          board[5][2] = pawn_black
          board[5][6] = pawn_black
          board[4][6] = pawn_black
        end
        it 'returns false' do
          expect(checkmate?(board, 'white')).to eql(false)
        end
      end
    end
    describe 'when its a black king' do
      describe 'and the king is not in checkmate' do
        before do
          board[4][4] = king_black
          board[5][5] = pawn_white
        end
        it 'returns false' do
          expect(checkmate?(board, 'black')).to eql(false)
        end
      end
      describe 'and the king is in checkmate' do
        before do
          board[4][4] = king_black
          board[0][4] = queen_white
          board[4][0] = rook_white
          board[0][0] = bishop_white
          board[6][6] = pawn_white
          board[0][3] = rook_white
          board[1][6] = knight_white
        end
        it 'returns true' do
          expect(checkmate?(board, 'black')).to eql(true)
        end
      end
      describe 'and the king is in checkmate by knights' do
        before do
          board[4][4] = king_black
          board[6][2] = knight_white
          board[6][3] = knight_white
          board[6][5] = knight_white
          board[6][6] = knight_white
          board[4][1] = knight_white
          board[4][7] = knight_white
          board[1][5] = knight_white
        end
        it 'returns true' do
          expect(checkmate?(board, 'black')).to eql(true)
        end
      end
      describe 'and the king is in checkmate by bishops' do
        before do
          board[4][4] = king_black
          board[2][0] = bishop_white
          board[2][1] = bishop_white
          board[2][2] = bishop_white
          board[2][3] = bishop_white
          board[2][4] = bishop_white
        end
        it 'returns true' do
          expect(checkmate?(board, 'black')).to eql(true)
        end
      end
      describe 'and the king is in checkmate by rooks' do
        before do
          board[4][4] = king_black
          board[0][3] = rook_white
          board[0][4] = rook_white
          board[0][5] = rook_white
        end
        it 'returns true' do
          expect(checkmate?(board, 'black')).to eql(true)
        end
      end
      describe 'and the king is in checkmate by queens' do
        before do
          board[4][4] = king_black
          board[0][3] = queen_white
          board[0][4] = queen_white
          board[0][5] = queen_white
        end
        it 'returns true' do
          expect(checkmate?(board, 'black')).to eql(true)
        end
      end
      describe 'and the king is in checkmate by pawns' do
        before do
          board[4][4] = king_black
          board[2][4] = pawn_white
          board[2][5] = pawn_white
          board[3][2] = pawn_white
          board[3][6] = pawn_white
          board[4][2] = pawn_white
          board[4][6] = pawn_white
          board[4][3] = pawn_white
          board[4][5] = pawn_white
        end
        it 'returns true' do
          expect(checkmate?(board, 'black')).to eql(true)
        end
      end
      describe 'and the king is in check by pawns but have 1 exit' do
        before do
          board[4][4] = king_black
          board[2][4] = pawn_white
          board[2][5] = pawn_white
          board[3][2] = pawn_white
          board[3][6] = pawn_white
          board[4][2] = pawn_white
          board[4][6] = pawn_white
        end
        it 'returns false' do
          expect(checkmate?(board, 'black')).to eql(false)
        end
      end
      describe 'and the king is in check by pawns but have 2 exits' do
        before do
          board[4][4] = king_black
          board[2][4] = pawn_white
          board[2][5] = pawn_white
          board[3][2] = pawn_white
          board[3][6] = pawn_white
          board[4][6] = pawn_white
        end
        it 'returns false' do
          expect(checkmate?(board, 'black')).to eql(false)
        end
      end
    end
  end
end
