require_relative '../lib/board'

describe Board do
  describe '#initialize' do
    describe 'when the board is just created' do
      it 'creates a 8x8 grid' do
        board = Board.new
        expect(board.grid.size).to eq(8)
        expect(board.grid.all? { |row| row.size == 8 }).to be true
      end
    end
  end

  describe '#[]' do
    describe 'when given a position' do
      it 'returns the piece at that position' do
        board = Board.new
        expect(board[[0, 0]]).to be_nil
      end
    end
  end

  describe '#[]=' do
    describe 'when given a position and a piece' do
      it 'sets the piece at that position' do
        board = Board.new
        board[[0, 0]] = :piece
        expect(board[[0, 0]]).to eq(:piece)
      end
    end
  end

  describe '#move_piece' do
    describe 'when given a start position and an end position' do
      it 'moves the piece from the start position to the end position' do
        board = Board.new
        board[[0, 0]] = :piece
        board.move_piece([0, 0], [1, 1])
        expect(board[[0, 0]]).to be_nil
        expect(board[[1, 1]]).to eq(:piece)
      end
    end
    describe 'when there is no piece at the start position' do
      it 'raises an error' do
        board = Board.new
        expect { board.move_piece([0, 0], [1, 1]) }.to raise_error("There is no piece at start_pos")
      end
    end
    describe 'when there is already a piece at the end position' do
      it 'raises an error' do
        board = Board.new
        board[[0, 0]] = :piece
        board[[1, 1]] = :piece
        expect { board.move_piece([0, 0], [1, 1]) }.to raise_error("There is already a piece at end_pos")
      end
    end
  end
  
  describe '#valid_pos?' do
    describe 'when given a position' do
      it 'returns true if the position is on the board' do
        board = Board.new
        expect(board.valid_pos?([0, 0])).to be true
      end
      it 'returns false if the position is off the board' do
        board = Board.new
        expect(board.valid_pos?([-1, 0])).to be false
      end
    end
  end

  describe '#add_piece' do
    describe 'when given a piece and a position' do
      it 'adds the piece to the board at the given position' do
        board = Board.new
        board.add_piece(:piece, [0, 0])
        expect(board[[0, 0]]).to eq(:piece)
      end
    end
  end

  describe '#remove_piece' do
    describe 'when given a position' do
      it 'removes the piece at the given position' do
        board = Board.new
        board[[0, 0]] = :piece
        board.remove_piece([0, 0])
        expect(board[[0, 0]]).to be_nil
      end
    end
  end
end