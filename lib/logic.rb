require_relative 'pieces'
require_relative 'pieces_moves'

module Logic
  extend Pieces
  extend PiecesMoves

  def check?(board, color)
    king_pos = find_king(board, color)
    return false if king_pos.nil?

    board.each_with_index do |row, row_index|
      row.each_with_index do |piece, col_index|
        next if piece == ' '

        moves = piece_moves(board, [row_index, col_index])
        return true if moves.include?(king_pos)
      end
    end
    false
  end

  def checkmate?(board, color)
    king_pos = find_king(board, color)
    return false if king_pos.nil?

    return true if check_king?(board, color, king_pos) && check_pieces?(board, color)

    false
  end

  private

  def check_king?(board, color, king_pos)
    king_moves = king_moves(board, king_pos, color)
    king_moves.each do |move|
      new_board = board.map(&:clone)
      new_board[king_pos[0]][king_pos[1]] = ' '
      new_board[move[0]][move[1]] = color == 'white' ? king_white : king_black
      return false unless check?(new_board, color)
    end
    true
  end

  def check_pieces?(board, color)
    board.each_with_index do |row, row_index|
      row.each_with_index do |piece, col_index|
        own_pieces = get_own_pieces(color)
        next unless own_pieces.include?(piece)

        moves = piece_moves(board, [row_index, col_index])
        moves.each do |move|
          new_board = board.map(&:clone)
          new_board[row_index][col_index] = ' '
          new_board[move[0]][move[1]] = piece
          return false unless check?(new_board, color)
        end
      end
    end
    true
  end

  def get_own_pieces(color)
    color == 'white' ? white_pieces : black_pieces
  end

  def find_king(board, color)
    board.each_with_index do |row, row_index|
      row.each_with_index do |piece, col_index|
        next if piece == ' '

        searching_piece = color == 'white' ? king_white : king_black
        return [row_index, col_index] if piece == searching_piece
      end
    end
    nil
  end

  def piece_moves(board, from, last_move = nil)
    piece = board[from[0]][from[1]]
    return [] if piece == ' '

    return pieces_moves_helper_white(board, from, piece, last_move) if white_pieces.include?(piece)
    return pieces_moves_helper_black(board, from, piece, last_move) if black_pieces.include?(piece)
  end

  def pieces_moves_helper_white(board, from, piece, last_move)
    return pawn_moves(board, from, 'white', last_move) if piece == pawn_white
    return rook_moves(board, from, 'white') if piece == rook_white
    return bishop_moves(board, from, 'white') if piece == bishop_white
    return knight_moves(board, from, 'white') if piece == knight_white
    return queen_moves(board, from, 'white') if piece == queen_white
    return king_moves(board, from, 'white') if piece == king_white
  end

  def pieces_moves_helper_black(board, from, piece, last_move)
    return pawn_moves(board, from, 'black', last_move) if piece == pawn_black
    return rook_moves(board, from, 'black') if piece == rook_black
    return bishop_moves(board, from, 'black') if piece == bishop_black
    return knight_moves(board, from, 'black') if piece == knight_black
    return queen_moves(board, from, 'black') if piece == queen_black
    return king_moves(board, from, 'black') if piece == king_black
  end
end
