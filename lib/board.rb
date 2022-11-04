require_relative 'pieces'

class Board
  include Pieces
  attr_reader :grid
  attr_accessor :history

  def initialize(grid = Array.new(8) { Array.new(8, ' ') })
    @grid = grid
    @history = []
  end

  def [](pos)
    x, y = pos
    grid[x][y]
  end

  def []=(pos, piece)
    x, y = pos
    grid[x][y] = piece
  end

  def move_piece(start_pos, end_pos)
    raise 'There is no piece at start_pos' if self[start_pos] == ' '
    raise 'There is already a piece at end_pos' unless self[end_pos] == ' '

    self[end_pos] = self[start_pos]
    self[start_pos] = ' '
  end

  def valid_pos?(pos)
    pos.all? { |coord| coord.between?(0, 7) }
  end

  def add_piece(piece, pos)
    raise 'position not empty' unless self[pos] == ' '

    self[pos] = piece
  end

  def remove_piece(pos)
    raise 'position empty' if self[pos] == ' '

    self[pos] = ' '
  end

  def setup_board
    @grid[0] = [rook_black, knight_black, bishop_black, queen_black,
                king_black, bishop_black, knight_black, rook_black]
    @grid[1] = [pawn_black, pawn_black, pawn_black, pawn_black,
                pawn_black, pawn_black, pawn_black, pawn_black]
    @grid[6] = [pawn_white, pawn_white, pawn_white, pawn_white,
                pawn_white, pawn_white, pawn_white, pawn_white]
    @grid[7] = [rook_white, knight_white, bishop_white, queen_white,
                king_white, bishop_white, knight_white, rook_white]
  end
end
