require_relative '../lib/pieces'

describe Pieces do
  include Pieces

  describe '#pawn_white' do
    it 'returns the white pawn' do
      expect(pawn_white).to eq('♙')
    end
  end
  describe '#pawn_black' do
    it 'returns the black pawn' do
      expect(pawn_black).to eq('♟')
    end
  end
  describe '#pawn_white_rotated' do
    it 'returns the white rotated pawn' do
      expect(pawn_white_rotated).to eq('🨎')
    end
  end
  describe '#pawn_black_rotated' do
    it 'returns the black rotated pawn' do
      expect(pawn_black_rotated).to eq('🨔')
    end
  end
  describe '#rook_white' do
    it 'returns the white rook' do
      expect(rook_white).to eq('♖')
    end
  end
  describe '#rook_black' do
    it 'returns the black rook' do
      expect(rook_black).to eq('♜')
    end
  end
  describe '#rook_white_rotated' do
    it 'returns the white rotated rook' do
      expect(rook_white_rotated).to eq('🨋')
    end
  end
  describe '#rook_black_rotated' do
    it 'returns the black rotated rook' do
      expect(rook_black_rotated).to eq('🨑')
    end
  end
  describe '#knight_white' do
    it 'returns the white knight' do
      expect(knight_white).to eq('♘')
    end
  end
  describe '#knight_black' do
    it 'returns the black knight' do
      expect(knight_black).to eq('♞')
    end
  end
  describe '#knight_white_rotated' do
    it 'returns the white rotated knight' do
      expect(knight_white_rotated).to eq('🨍')
    end
  end
  describe '#knight_black_rotated' do
    it 'returns the black rotated knight' do
      expect(knight_black_rotated).to eq('🨓')
    end
  end
  describe '#bishop_white' do
    it 'returns the white bishop' do
      expect(bishop_white).to eq('♗')
    end
  end
  describe '#bishop_black' do
    it 'returns the black bishop' do
      expect(bishop_black).to eq('♝')
    end
  end
  describe '#bishop_white_rotated' do
    it 'returns the white rotated bishop' do
      expect(bishop_white_rotated).to eq('🨌')
    end
  end
  describe '#bishop_black_rotated' do
    it 'returns the black rotated bishop' do
      expect(bishop_black_rotated).to eq('🨒')
    end
  end
  describe '#queen_white' do
    it 'returns the white queen' do
      expect(queen_white).to eq('♕')
    end
  end
  describe '#queen_black' do
    it 'returns the black queen' do
      expect(queen_black).to eq('♛')
    end
  end
  describe '#queen_white_rotated' do
    it 'returns the white rotated queen' do
      expect(queen_white_rotated).to eq('🨊')
    end
  end
  describe '#queen_black_rotated' do
    it 'returns the black rotated queen' do
      expect(queen_black_rotated).to eq('🨐')
    end
  end
  describe '#king_white' do
    it 'returns the white king' do
      expect(king_white).to eq('♔')
    end
  end
  describe '#king_black' do
    it 'returns the black king' do
      expect(king_black).to eq('♚')
    end
  end
  describe '#king_white_rotated' do
    it 'returns the white rotated king' do
      expect(king_white_rotated).to eq('🨉')
    end
  end
  describe '#king_black_rotated' do
    it 'returns the black rotated king' do
      expect(king_black_rotated).to eq('🨏')
    end
  end
end
