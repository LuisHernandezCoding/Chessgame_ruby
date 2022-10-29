require_relative '../lib/pieces_moves'
require_relative '../lib/pieces'

describe PiecesMoves do
  include PiecesMoves
  include Pieces

  let(:board) { Array.new(8) { Array.new(8, ' ') } }

  describe '#pawn_moves' do
    describe 'when its white pawn' do
      describe 'when its in the first row' do
        before do
          include Pieces
          board[1][3] = pawn_white
        end
        it 'returns the possible moves' do
          expect(pawn_moves(board, [1, 3], 'white')).to eql([[2, 3], [3, 3]])
        end
      end
      describe 'when its in the second row' do
        before do
          board[2][3] = pawn_white
        end
        it 'returns the possible moves' do
          expect(pawn_moves(board, [2, 3], 'white')).to eql([[3, 3]])
        end
      end
      describe 'when its in the last row' do
        before do
          board[7][3] = pawn_white
        end
        it 'returns the possible moves' do
          expect(pawn_moves(board, [7, 3], 'white')).to eql([])
        end
      end
      describe 'when its in the middle row' do
        describe 'when there is no piece in front of it' do
          before do
            board[4][3] = pawn_white
          end
          it 'returns the possible moves' do
            expect(pawn_moves(board, [4, 3], 'white')).to eql([[5, 3]])
          end
        end
        describe 'when there is a piece in front of it' do
          before do
            board[4][3] = pawn_white
            board[5][3] = pawn_black
          end
          it 'returns the possible moves' do
            expect(pawn_moves(board, [4, 3], 'white')).to eql([])
          end
        end
        describe 'when there is a piece in front of it and in the diagonal' do
          before do
            board[4][3] = pawn_white
            board[5][3] = pawn_black
            board[5][2] = pawn_black
          end
          it 'returns the possible moves' do
            expect(pawn_moves(board, [4, 3], 'white')).to eql([[5, 2]])
          end
        end
      end
    end
    describe 'when its black pawn' do
      describe 'when its in the first row' do
        before do
          board[6][3] = pawn_black
        end
        it 'returns the possible moves' do
          expect(pawn_moves(board, [6, 3], 'black')).to eql([[5, 3], [4, 3]])
        end
      end
      describe 'when its in the second row' do
        before do
          board[5][3] = pawn_black
        end
        it 'returns the possible moves' do
          expect(pawn_moves(board, [5, 3], 'black')).to eql([[4, 3]])
        end
      end
      describe 'when its in the last row' do
        before do
          board[0][3] = pawn_black
        end
        it 'returns the possible moves' do
          expect(pawn_moves(board, [0, 3], 'black')).to eql([])
        end
      end
      describe 'when its in the middle row' do
        describe 'when there is no piece in front of it' do
          before do
            board[3][3] = pawn_black
          end
          it 'returns the possible moves' do
            expect(pawn_moves(board, [3, 3], 'black')).to eql([[2, 3]])
          end
        end
        describe 'when there is a piece in front of it' do
          before do
            board[3][3] = pawn_black
            board[2][3] = pawn_white
          end
          it 'returns the possible moves' do
            expect(pawn_moves(board, [3, 3], 'black')).to eql([])
          end
        end
        describe 'when there is a piece in front of it and in the diagonal' do
          before do
            board[3][3] = pawn_black
            board[2][3] = pawn_white
            board[2][2] = pawn_white
          end
          it 'returns the possible moves' do
            expect(pawn_moves(board, [3, 3], 'black')).to eql([[2, 2]])
          end
        end
      end
    end
  end

  describe '#rook_moves' do
    describe 'when its white rook' do
      describe 'Vertical' do
        describe 'when its in the first row' do
          before do
            board[0][3] = rook_white
            board[0][4] = pawn_white
            board[0][2] = pawn_white
          end
          it 'returns the possible moves' do
            expect(rook_moves(board, [0, 3], 'white')).to eql([[1, 3], [2, 3], [3, 3], [4, 3], [5, 3], [6, 3], [7, 3]])
          end
        end
        describe 'when its in the second row' do
          before do
            board[1][3] = rook_white
            board[1][4] = pawn_white
            board[1][2] = pawn_white
          end
          it 'returns the possible moves' do
            expect(rook_moves(board, [1, 3], 'white')).to eql([[2, 3], [3, 3], [4, 3], [5, 3], [6, 3], [7, 3], [0, 3]])
          end
        end
        describe 'when its in the last row' do
          before do
            board[7][3] = rook_white
            board[7][4] = pawn_white
            board[7][2] = pawn_white
          end
          it 'returns the possible moves' do
            expect(rook_moves(board, [7, 3], 'white')).to eql([[6, 3], [5, 3], [4, 3], [3, 3], [2, 3], [1, 3], [0, 3]])
          end
        end
        describe 'when its in the middle row' do
          describe 'when there is no piece in front of it' do
            before do
              board[4][3] = rook_white
              board[4][4] = pawn_white
              board[4][2] = pawn_white
            end
            it 'returns the possible moves' do
              expect(rook_moves(board, [4, 3],
                                'white')).to eql([[5, 3], [6, 3], [7, 3], [3, 3], [2, 3], [1, 3], [0, 3]])
            end
          end
          describe 'when there is a piece in front of it' do
            before do
              board[4][3] = rook_white
              board[4][4] = pawn_white
              board[4][2] = pawn_white
              board[5][3] = pawn_black
            end
            it 'returns the possible moves' do
              expect(rook_moves(board, [4, 3], 'white')).to eql([[5, 3], [3, 3], [2, 3], [1, 3], [0, 3]])
            end
          end
          describe 'when there is a piece in front of it but 2 sqares of distance' do
            before do
              board[4][3] = rook_white
              board[4][4] = pawn_white
              board[4][2] = pawn_white
              board[4][5] = pawn_black
            end
            it 'returns the possible moves' do
              expect(rook_moves(board, [4, 3],
                                'white')).to eql([[5, 3], [6, 3], [7, 3], [3, 3], [2, 3], [1, 3], [0, 3]])
            end
          end
        end
      end
      describe 'Horizontal' do
        describe 'when its in the first column' do
          before do
            board[3][0] = rook_white
            board[4][0] = pawn_white
            board[2][0] = pawn_white
          end
          it 'returns the possible moves' do
            expect(rook_moves(board, [3, 0], 'white')).to eql([[3, 1], [3, 2], [3, 3], [3, 4], [3, 5], [3, 6], [3, 7]])
          end
        end
        describe 'when its in the second column' do
          before do
            board[3][1] = rook_white
            board[4][1] = pawn_white
            board[2][1] = pawn_white
          end
          it 'returns the possible moves' do
            expect(rook_moves(board, [3, 1], 'white')).to eql([[3, 2], [3, 3], [3, 4], [3, 5], [3, 6], [3, 7], [3, 0]])
          end
        end
        describe 'when its in the last column' do
          before do
            board[3][7] = rook_white
            board[4][7] = pawn_white
            board[2][7] = pawn_white
          end
          it 'returns the possible moves' do
            expect(rook_moves(board, [3, 7], 'white')).to eql([[3, 6], [3, 5], [3, 4], [3, 3], [3, 2], [3, 1], [3, 0]])
          end
        end
        describe 'when its in the middle column' do
          describe 'when there is no piece in front of it' do
            before do
              board[3][4] = rook_white
              board[4][4] = pawn_white
              board[2][4] = pawn_white
            end
            it 'returns the possible moves' do
              expect(rook_moves(board, [3, 4],
                                'white')).to eql([[3, 5], [3, 6], [3, 7], [3, 3], [3, 2], [3, 1], [3, 0]])
            end
          end
          describe 'when there is a piece in front of it' do
            before do
              board[3][4] = rook_white
              board[4][4] = pawn_white
              board[2][4] = pawn_white
              board[3][5] = pawn_black
            end
            it 'returns the possible moves' do
              expect(rook_moves(board, [3, 4], 'white')).to eql([[3, 5], [3, 3], [3, 2], [3, 1], [3, 0]])
            end
          end
          describe 'when there is a piece in front of it but 2 sqares of distance' do
            before do
              board[3][4] = rook_white
              board[4][4] = pawn_white
              board[2][4] = pawn_white
              board[3][6] = pawn_black
            end
            it 'returns the possible moves' do
              expect(rook_moves(board, [3, 4], 'white')).to eql([[3, 5], [3, 6], [3, 3], [3, 2], [3, 1], [3, 0]])
            end
          end
        end
      end
    end
    describe 'when its black rook' do
      describe 'Vertical' do
        describe 'when its in the first row' do
          before do
            board[0][3] = rook_black
            board[1][3] = pawn_black
            board[2][3] = pawn_black
          end
          it 'returns the possible moves' do
            expect(rook_moves(board, [0, 3], 'black')).to eql([[0, 4], [0, 5], [0, 6], [0, 7], [0, 2], [0, 1], [0, 0]])
          end
        end
        describe 'when its in the second row' do
          before do
            board[1][3] = rook_black
            board[2][3] = pawn_black
            board[0][3] = pawn_black
          end
          it 'returns the possible moves' do
            expect(rook_moves(board, [1, 3], 'black')).to eql([[1, 4], [1, 5], [1, 6], [1, 7], [1, 2], [1, 1], [1, 0]])
          end
        end
        describe 'when its in the last row' do
          before do
            board[7][3] = rook_black
            board[6][3] = pawn_black
            board[5][3] = pawn_black
          end
          it 'returns the possible moves' do
            expect(rook_moves(board, [7, 3], 'black')).to eql([[7, 4], [7, 5], [7, 6], [7, 7], [7, 2], [7, 1], [7, 0]])
          end
        end
        describe 'when its in the middle row' do
          describe 'when there is no piece in front of it' do
            before do
              board[4][3] = rook_black
              board[5][3] = pawn_black
              board[3][3] = pawn_black
            end
            it 'returns the possible moves' do
              expect(rook_moves(board, [4, 3],
                                'black')).to eql([[4, 4], [4, 5], [4, 6], [4, 7], [4, 2], [4, 1], [4, 0]])
            end
          end
          describe 'when there is a piece in front of it' do
            before do
              board[4][3] = rook_black
              board[5][3] = pawn_black
              board[3][3] = pawn_black
              board[4][4] = pawn_white
            end
            it 'returns the possible moves' do
              expect(rook_moves(board, [4, 3], 'black')).to eql([[4, 4], [4, 2], [4, 1], [4, 0]])
            end
          end
          describe 'when there is a piece in front of it but 2 sqares of distance' do
            before do
              board[4][3] = rook_black
              board[5][3] = pawn_black
              board[3][3] = pawn_black
              board[4][5] = pawn_white
            end
            it 'returns the possible moves' do
              expect(rook_moves(board, [4, 3], 'black')).to eql([[4, 4], [4, 5], [4, 2], [4, 1], [4, 0]])
            end
          end
        end
      end
      describe 'Horizontal' do
        describe 'when its in the first column' do
          before do
            board[3][0] = rook_black
            board[3][1] = pawn_black
            board[3][2] = pawn_black
          end
          it 'returns the possible moves' do
            expect(rook_moves(board, [3, 0], 'black')).to eql([[4, 0], [5, 0], [6, 0], [7, 0], [2, 0], [1, 0], [0, 0]])
          end
        end
        describe 'when its in the second column' do
          before do
            board[3][1] = rook_black
            board[3][2] = pawn_black
            board[3][0] = pawn_black
          end
          it 'returns the possible moves' do
            expect(rook_moves(board, [3, 1], 'black')).to eql([[4, 1], [5, 1], [6, 1], [7, 1], [2, 1], [1, 1], [0, 1]])
          end
        end
        describe 'when its in the last column' do
          before do
            board[3][7] = rook_black
            board[3][6] = pawn_black
            board[3][5] = pawn_black
          end
          it 'returns the possible moves' do
            expect(rook_moves(board, [3, 7], 'black')).to eql([[4, 7], [5, 7], [6, 7], [7, 7], [2, 7], [1, 7], [0, 7]])
          end
        end
        describe 'when its in the middle column' do
          describe 'when there is no piece in front of it' do
            before do
              board[3][4] = rook_black
              board[3][5] = pawn_black
              board[3][3] = pawn_black
            end
            it 'returns the possible moves' do
              expect(rook_moves(board, [3, 4],
                                'black')).to eql([[4, 4], [5, 4], [6, 4], [7, 4], [2, 4], [1, 4], [0, 4]])
            end
          end
          describe 'when there is a piece in front of it' do
            before do
              board[3][4] = rook_black
              board[3][5] = pawn_black
              board[3][3] = pawn_black
              board[4][4] = pawn_white
            end
            it 'returns the possible moves' do
              expect(rook_moves(board, [3, 4], 'black')).to eql([[4, 4], [2, 4], [1, 4], [0, 4]])
            end
          end
          describe 'when there is a piece in front of it but 2 sqares of distance' do
            before do
              board[3][4] = rook_black
              board[3][5] = pawn_black
              board[3][3] = pawn_black
              board[4][4] = pawn_white
              board[2][4] = pawn_white
            end
            it 'returns the possible moves' do
              expect(rook_moves(board, [3, 4], 'black')).to eql([[4, 4], [2, 4]])
            end
          end
        end
      end
    end
  end
end
